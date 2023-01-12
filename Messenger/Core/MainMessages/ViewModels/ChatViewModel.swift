//
//  ChatViewModel.swift
//  Messenger
//
//  Created by Амир Кайдаров on 1/11/23.
//

import Foundation
import Firebase
import FirebaseFirestore

class ChatViewModel : ObservableObject {
    @Published var chatText = ""
    @Published var errorMessage = ""
    @Published var chatMessages = [ChatMessage]()
    @Published var count = 0
    
    var userService = UserService()
    
    let chatUser : ChatUser?
    
    init(chatUser : ChatUser?) {
        self.chatUser = chatUser
        fetchMessages()
    }
    
    func fetchMessages() {
        guard let fromID = Auth.auth().currentUser?.uid else { return }
        guard let toID = chatUser?.id else { return }
        
        let conversationID = getConversationID(of: fromID, with: toID)
        
        Firestore.firestore().collection("messages")
            .document("messages")
            .collection(conversationID)
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
                if error != nil {
                    self.errorMessage = "Failed to upload messages"
                    return
                }
                snapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        guard let chatMessage = try? change.document.data(as: ChatMessage.self) else { return  }
                        self.chatMessages.append(chatMessage)
                        self.count += 1
                    }
                })
            }
    }
    
    func send(){
        guard let fromID = Auth.auth().currentUser?.uid else { return }
        guard let toID = chatUser?.id else { return }
        
        let conversationID = getConversationID(of: fromID, with: toID)
        
        let document = Firestore.firestore().collection("messages")
            .document("messages")
            .collection(conversationID)
            .document()
        
        let data : [String : Any] = ["fromID": fromID,
                                     "toID": toID,
                                     "text": chatText,
                                     "timestamp": Timestamp()]
        
        document.setData(data) { error in
            if error != nil {
                self.errorMessage = "Failed to send the message"
                return
            }
            
            self.persistRecentMessage {
                self.errorMessage = ""
                self.chatText = ""
            }
            
        }
        
    }
    
    func isSentByCurrentUser(_ chatMessage : ChatMessage) -> Bool {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return false }
        return chatMessage.fromID == currentUserID
    }
    
    private func getConversationID(of fromID : String, with toID: String) -> String {
        let firstID = fromID < toID ? fromID : toID
        let secondID = fromID < toID ? toID : fromID
        
        return firstID + secondID
    }
    
    private func persistRecentMessage(completion : @escaping() -> Void ) {
        guard let fromID = Auth.auth().currentUser?.uid else { return }
        guard let toID = chatUser?.id else { return }
        
        let fromDocument = Firestore.firestore().collection("recent_messages")
            .document(fromID)
            .collection("messages")
            .document(toID)
        
        guard let chatUser = chatUser else { return }
        
        let fromData : [String : Any] = [
            "timestamp": Timestamp(),
            "text": self.chatText,
            "fromID": fromID,
            "toID": toID,
            "username": chatUser.username,
            "imageURL": chatUser.imageURL
        ]
        
        fromDocument.setData(fromData) { error in
            if error != nil {
                self.errorMessage = "Failed to save recent messages"
                return
            }
        }
        
        userService.fetchUser(with: fromID) { currentUser in
            let toDocument = Firestore.firestore().collection("recent_messages")
                .document(toID)
                .collection("messages")
                .document(fromID)
            
            let toData : [String : Any] = [
                "timestamp": Timestamp(),
                "text": self.chatText,
                "fromID": fromID,
                "toID": toID,
                "username": currentUser.username,
                "imageURL": currentUser.imageURL
            ]
            
            toDocument.setData(toData) { error in
                if error != nil {
                    self.errorMessage = "Failed to save recent messages"
                    return
                }
            }
        }
        
    }
}
