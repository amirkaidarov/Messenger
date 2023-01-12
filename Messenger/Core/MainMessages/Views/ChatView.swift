//
//  ChatView.swift
//  Messenger
//
//  Created by Амир Кайдаров on 1/10/23.
//

import SwiftUI

struct ChatView: View {
    let chatUser : ChatUser?
    @ObservedObject var chatViewModel : ChatViewModel
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        
        self.chatViewModel = ChatViewModel(chatUser: chatUser)
    }
    
    var body: some View {
        ZStack{
            messagesColumn
                .navigationTitle(chatUser?.username ?? "")
                .navigationBarTitleDisplayMode(.inline)
            Text(chatViewModel.errorMessage)
        }
    }
}

extension ChatView {
    
    private var messagesColumn : some View {
        ScrollView {
            ScrollViewReader { proxy in
                ForEach(chatViewModel.chatMessages) { message in
                    MessageView(message: message,
                                isSentByCurrentUser: chatViewModel.isSentByCurrentUser(message))
                }
                HStack { Spacer() }
                    .id("Empty")
                    .onReceive(chatViewModel.$count) { _ in
                        withAnimation(.easeOut(duration: 0.5)) {
                            DispatchQueue.main.async {
                                proxy.scrollTo("Empty", anchor: .bottom)
                            }
                        }
                    }
            }
        }
        .safeAreaInset(edge: .bottom) {
            bottomBar
                .background(Color(
                    .systemBackground)
                    .ignoresSafeArea())
        }
        .background(Color(.init(white: 0.95, alpha: 1))
            .edgesIgnoringSafeArea([])
        )
    }
    
    private var bottomBar : some View {
        HStack (alignment : .bottom,spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
            TextField("Message...", text: $chatViewModel.chatText, axis: .vertical)
                .lineLimit(5)
            Button {
                chatViewModel.send()
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
