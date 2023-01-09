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
    
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    
    @State var loginStatusMessege = ""
    @State var shouldShowImagePicker = false
    @State var image : UIImage?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (spacing: 16){
                    Picker(selection: $isLoginMode) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    } label: {
                        Text("Picker")
                    }
                    .pickerStyle(.segmented)
                    
                    if !isLoginMode {
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
                        SecureField("Password", text: $password)
                    }
                    .padding(12)
                    .background(Color.white)
                    
                    Button {
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Log In" : "Create Account")
                                .padding(.vertical, 8)
                            Spacer()
                        }
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .font(.system(size: 14, weight: .semibold))
                    }
                    
                    Text(self.loginStatusMessege)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
                .padding()
            }
            .navigationTitle(isLoginMode ? "Log In" : "Create Account")
            .background(Color(.init(white: 0, alpha: 0.05))
                .ignoresSafeArea())
        }
        .fullScreenCover(isPresented: $shouldShowImagePicker) {
            ImagePicker(image: $image)
        }
    }
    
    
    private func handleAction() {
        if isLoginMode {
            loginUser()
        } else {
            createNewAccount()
        }
    }
    
    private func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.loginStatusMessege = error.localizedDescription
                return
            }
            self.loginStatusMessege = ""
        }
    }
    
    private func createNewAccount() {
        if image == nil {
            self.loginStatusMessege = "Please provide profile photo"
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.loginStatusMessege = error.localizedDescription
                return
            }
            self.loginStatusMessege = ""
            
            self.persistImageToStorage()
        }
        
    }
    
    private func persistImageToStorage() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Storage.storage().reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData) { metadata, error in
            if let error = error {
                self.loginStatusMessege = error.localizedDescription
                return
            }
            
            ref.downloadURL { url, error in
                if let error = error {
                    self.loginStatusMessege = error.localizedDescription
                }
                
                guard let url = url else { return }
                storeUserProfileImage(with: url)
                
                return
            }
            
            self.loginStatusMessege = ""
        }
    }
    
    private func storeUserProfileImage(with url : URL) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userData = ["email": email, "uid": uid, "profileImageURL": url.absoluteString]
        Firestore.firestore().collection("users")
            .document(uid).setData(userData) { error in
                if let error = error {
                    self.loginStatusMessege = error.localizedDescription
                    return
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
