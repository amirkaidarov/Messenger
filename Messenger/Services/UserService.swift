//
//  UserService.swift
//  Messenger
//
//  Created by Амир Кайдаров on 1/9/23.
//

import Foundation
import Firebase
import FirebaseFirestore

struct UserService {
    
    func fetchUser(with uid : String, completion : @escaping(ChatUser) -> Void) {
        Firestore.firestore().collection("users")
            .document(uid)
            .getDocument { snapshot, error in
                guard let snapshot = snapshot else { return }
                guard let chatUser  = try? snapshot.data(as: ChatUser.self) else { return }
                completion(chatUser)
            }
    }
    
    func fetchUsers(completion : @escaping([ChatUser]) -> Void) {
        Firestore.firestore().collection("users")
            .getDocuments { documentsSnapshot, error in
                if let error = error {
                    print("error fetching users from firebase")
                    return
                }
                
                guard let documents = documentsSnapshot?.documents else { return }
                
                var users = [ChatUser]()
                
                documents.forEach { documentSnapshot in
                    guard let user = try? documentSnapshot.data(as: ChatUser.self) else { return }
                    users.append(user)
                }
                
                completion(users)
            }
    }
}

