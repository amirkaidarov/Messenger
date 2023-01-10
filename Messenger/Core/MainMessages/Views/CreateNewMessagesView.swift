//
//  NewMessagesView.swift
//  Messenger
//
//  Created by Амир Кайдаров on 1/10/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct CreateNewMessagesView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var createNewMessagesViewModel = CreateNewMessagesViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(createNewMessagesViewModel.chatUsers) { chatUser in
                    Button {
                        //
                    } label: {
                        HStack (spacing: 16) {
                            WebImage(url: URL(string: chatUser.imageURL))
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(50)
                                .overlay(RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color(.label), lineWidth: 1))
                            
                            Text(chatUser.username)
                            Spacer()
                        }
                        .foregroundColor(Color(.label))
                        .padding(.horizontal)
                        Divider()
                    }

                }
            }
            .navigationTitle("New Message")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                    
                }
            }
        }
    }
}

struct NewMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewMessagesView()
    }
}
