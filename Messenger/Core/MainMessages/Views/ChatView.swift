//
//  ChatView.swift
//  Messenger
//
//  Created by Амир Кайдаров on 1/10/23.
//

import SwiftUI

struct ChatView: View {
    let chatUser : ChatUser?
    
    @State var chatText = ""
    
    var body: some View {
        ZStack {
            messagesColumn
            
            VStack {
                Spacer()
                bottomBar
                    .background(Color(.systemBackground))
            }
            
        }
        .navigationTitle(chatUser?.username ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension ChatView {
    
    private var messagesColumn : some View {
        ScrollView {
            ForEach(0..<20) { _ in
                HStack {
                    Spacer()
                    HStack {
                        Text("Hello")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            HStack { Spacer() }
                .frame(height: 70)
        }
        .background(Color(.init(white: 0.95, alpha: 1)).edgesIgnoringSafeArea([]))
    }
    
    private var bottomBar : some View {
        HStack (spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
            TextField("Message...", text: $chatText, axis: .vertical)
                .lineLimit(5)
            Button {
                //
            } label: {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 24))
            }
            
            
        }
        .padding()
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatView(chatUser: ChatUser(id: "8O3mr9uadBOnRQ9OWAZwcT9mqjt2",
                                        username: "test",
                                        email: "test@mail.com",
                                        imageURL: "https://firebasestorage.googleapis.com:443/v0/b/messenger-2d3f4.appspot.com/o/8O3mr9uadBOnRQ9OWAZwcT9mqjt2?alt=media&token=7149eec6-5e14-4aa9-8d47-60e682a4a289"))
        }
    }
}
