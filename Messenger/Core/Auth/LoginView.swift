//
//  ContentView.swift
//  Messenger
//
//  Created by Амир Кайдаров on 1/8/23.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct LoginView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State var email = ""
    @State var username = ""
    @State var password = ""

    @State var shouldShowImagePicker = false
    @State var image : UIImage?
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (spacing: 16){
                    Picker(selection: $viewModel.isLoginMode) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    } label: {
                        Text("Picker")
                    }
                    .pickerStyle(.segmented)
                    
                    if !$viewModel.isLoginMode.wrappedValue {
                        Button {
                            shouldShowImagePicker.toggle()
                        } label: {
                            VStack {
                                if let image = image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 128, height: 128)
                                        .scaledToFill()
                                        .cornerRadius(64)
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 64))
                                        .padding()
                                        .foregroundColor(Color(.label))
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 64)
                                .stroke(Color.black, lineWidth: 3))
                        }
                    }
                    
                    Group {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        if !$viewModel.isLoginMode.wrappedValue {
                            TextField("Username", text: $username)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        SecureField("Password", text: $password)
                    }
                    .padding(12)
                    .background(Color.white)
                    
                    Button {
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text($viewModel.isLoginMode.wrappedValue ? "Log In" : "Create Account")
                                .padding(.vertical, 8)
                            Spacer()
                        }
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .font(.system(size: 14, weight: .semibold))
                    }
                    
                    Text($viewModel.loginStatusMessege.wrappedValue)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
                .padding()
            }
            .navigationTitle($viewModel.isLoginMode.wrappedValue ? "Log In" : "Create Account")
            .background(Color(.init(white: 0, alpha: 0.05))
                .ignoresSafeArea())
        }
        .fullScreenCover(isPresented: $shouldShowImagePicker) {
            ImagePicker(image: $image)
        }
    }
    
    
    private func handleAction() {
        if $viewModel.isLoginMode.wrappedValue {
            viewModel.login(email: email,
                            password: password) {
                email = ""
                password = ""
            }
        } else {
            viewModel.register(email: email,
                               password: password,
                               image: image,
                               username: username) {
                email = ""
                password = ""
                username = ""
                image = nil
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
