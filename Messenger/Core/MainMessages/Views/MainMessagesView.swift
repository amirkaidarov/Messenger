//
//  MainMessagesView.swift
//  Messenger
//
//  Created by Амир Кайдаров on 1/9/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct MainMessagesView: View {
    @State private var shouldShowLogoutOptions = false
    @State private var shouldShowMessageScreen = false
    @ObservedObject private var messagesViewModel = MainMessagesViewModel()
    @EnvironmentObject var authViewModel : AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                navigationBar
                
                messagesView
            }
            .overlay(
                newMessageButton, alignment: .bottom)
            .toolbar(.hidden)
        }
    }
}

extension MainMessagesView {
    private var navigationBar : some View {
        HStack (spacing: 16) {
            
            WebImage(url: URL(string: $authViewModel.currentUser.wrappedValue?.imageURL ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(50)
                .overlay(RoundedRectangle(cornerRadius: 44)
                    .stroke(Color(.label), lineWidth: 1))
                .shadow(radius: 5)
            
            VStack (alignment: .leading, spacing: 4){
                Text($authViewModel.currentUser.wrappedValue?.username ?? "")
                    .font(.system(size: 24, weight: .bold))
                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                }
            }
            Spacer()
            Button {
                shouldShowLogoutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            }
        }
        .padding()
        .confirmationDialog(
            Text("Settings"),
            isPresented: $shouldShowLogoutOptions
        ) {
            Button("Sign Out", role: .destructive) {
                authViewModel.signOut()
            }
            Button("Cancel", role: .cancel) {
                
            }
        } message: {
            Text("What do you want to do?")
        }
    }
    
    private var newMessageButton : some View {
        Button {
            shouldShowMessageScreen.toggle()
        } label: {
            HStack {
                Spacer()
                Text("+ New Message")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
            .background(Color.blue)
            .cornerRadius(32)
            .padding(.horizontal)
            .shadow(radius: 15)
        }
        .fullScreenCover(isPresented: $shouldShowMessageScreen) {
            CreateNewMessagesView()
        }
    }
    
    private var messagesView : some View {
        ScrollView {
            ForEach(1..<10, id : \.self) { _ in
                Group {
                    HStack (spacing : 16){
                        Image(systemName: "person.fill")
                            .font(.system(size: 32))
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 44)
                                .stroke(Color(.label), lineWidth: 1))
                        VStack (alignment: .leading){
                            Text("Username")
                                .font(.system(size: 16, weight: .bold))
                            Text("Message sent to user")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(.lightGray))
                        }
                        Spacer()
                        Text("22d")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    Divider()
                        .padding(.vertical, 8)
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 50)
        }
    }
}



struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
            .environmentObject(AuthViewModel())
    }
}

