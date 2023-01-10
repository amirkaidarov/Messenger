//
//  CreateNewMessagesViewModel.swift
//  Messenger
//
//  Created by Амир Кайдаров on 1/10/23.
//

import Foundation
import Firebase
import FirebaseFirestore

class CreateNewMessagesViewModel : ObservableObject {
    let userService = UserService()
    @Published var chatUsers = [ChatUser]()
    
    init() {
        self.fetchUsers()
    }
    
    func fetchUsers() {
        userService.fetchUsers { chatUsers in
            self.chatUsers = chatUsers
        }
    }
}
