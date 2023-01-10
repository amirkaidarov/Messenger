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
    
    init() {
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = Auth.auth().currentUser?.uid == nil
        }
    }
}
