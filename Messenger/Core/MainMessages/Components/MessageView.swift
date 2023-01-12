//
//  MessageView.swift
//  Messenger
//
//  Created by Амир Кайдаров on 1/12/23.
//

import SwiftUI

struct MessageView: View {
    let message : ChatMessage
    let isSentByCurrentUser : Bool
    
    init(message: ChatMessage, isSentByCurrentUser: Bool) {
        self.message = message
        self.isSentByCurrentUser = isSentByCurrentUser
    }
    
    var body: some View {
        HStack {
            if isSentByCurrentUser {
                Spacer()
            }
            
            HStack {
                Text(message.text)
                    .foregroundColor(isSentByCurrentUser ? .white : .black)
            }
            .padding()
            .background(isSentByCurrentUser ? Color.blue : Color.white)
            .cornerRadius(8)
            
            if !isSentByCurrentUser {
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

//struct MessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageView()
//    }
//}
