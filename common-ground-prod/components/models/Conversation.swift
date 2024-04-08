import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct Conversation: Identifiable, Codable {
    @DocumentID var id: String?
    var lastMessage: String?
    var lastMessageTimestamp: Date?
    var participants: [String]
    var unreadCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case lastMessage
        case lastMessageTimestamp
        case participants
        case unreadCount
    }
}

struct Message: Codable, Identifiable {
    
    @DocumentID var id: String?
    let senderId: String
    let recipientId: String
    let text: String
    let timestamp: Date
    let favorite: Bool
    
    
}

//
//struct ChatUser: Codable
