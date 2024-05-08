import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct Conversation: Identifiable, Codable {
    @DocumentID var id: String?
    var participants: [String: String]  // Mapping from userID to displayName
    var lastMessage: String?
    var lastMessageTimestamp: Date?
    var lastRead: [String: Date]
    
    enum CodingKeys: String, CodingKey {
        case id
        case participants
        case lastMessage
        case lastMessageTimestamp
        case lastRead
    }
}

struct Message: Codable, Identifiable {
    
    @DocumentID var id: String?
    let senderId: String
    let recipientId: String
    let text: String
    let timestamp: Date
    var favorite: Bool
    
    
}

//
//struct ChatUser: Codable

//struct Participant: Codable {
//    var userID: String
//    var displayName: String
//}
