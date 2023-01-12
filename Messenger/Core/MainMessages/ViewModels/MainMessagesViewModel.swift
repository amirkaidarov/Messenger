//
//  MainMessagesViewModel.swift
//  Messenger
//
//  Created by Амир Кайдаров on 1/9/23.
//

import Foundation
import Firebase
import FirebaseFirestore

class MainMessagesViewModel : ObservableObject {
    @Published var chatUser : ChatUser?
    @Published var isUserCurrentlyLoggedOut = false
    @Published var recentMessages = [RecentMessage]()
    
    init() {
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = Auth.auth().currentUser?.uid == nil
        }
        
        fetchRecentMessages()
    }
    
    
    func fetchRecentMessages() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("recent_messages")
            .document(uid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
                if error != nil {
                    print("Failed to fetch recent messages")
                    return
                }
                
                snapshot?.documentChanges.forEach({ change in
                    guard let recentMessage = try? change.document.data(as: RecentMessage.self) else { return  }
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        rm.id == recentMessage.id
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                    self.recentMessages.insert(recentMessage, at: 0)
                })
                
            }
        
    }
}
