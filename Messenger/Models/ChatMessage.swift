//
//  ChatMessage.swift
//  Messenger
//
//  Created by Амир Кайдаров on 1/12/23.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct ChatMessage : Identifiable, Codable {
    @DocumentID var id : String?
    let fromID : String
    let toID : String
    let text : String
}
