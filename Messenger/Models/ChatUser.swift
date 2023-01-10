//
//  User.swift
//  Messenger
//
//  Created by Амир Кайдаров on 1/9/23.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct ChatUser : Identifiable, Codable {
    @DocumentID var id : String?
    let username : String
    let email : String
    let imageURL : String
}
