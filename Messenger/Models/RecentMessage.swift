//
//  RecentMessage.swift
//  Messenger
//
//  Created by Амир Кайдаров on 1/12/23.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct RecentMessage : Identifiable, Codable {
    @DocumentID var id : String?
    let text : String
    let fromID : String
    let toID : String
    let username : String
    let imageURL : String
    let timestamp : Date
    
    var timeAgo : String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}
