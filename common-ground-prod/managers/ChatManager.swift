//
//  ChatManager.swift
//  common-ground-prod
//
//  Created by dan crowley on 3/28/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


final class ChatManager {
    
    private let db = Firestore.firestore()
    
    static let shared = ChatManager()
    private init() { }
    
    func fetchConversations(userId: String) async throws -> [Conversation] {
        let snapshot = try await db.collection("users").document(userId).collection("conversations").getDocuments()
        
        for document in snapshot.documents {
            print("Document ID: \(document.documentID), Data: \(document.data())")
        }
        
        return snapshot.documents.compactMap { document -> Conversation? in
            do {
                return try document.data(as: Conversation.self)
            } catch {
                print("Error decoding conversation: \(error)")
                return nil
            }
        }
        
    
    }
    
    func fetchMessages(conversationId: String, userId: String) async throws -> [Message] {
        let snapshot = try await db.collection("users").document(userId).collection("conversations").document(conversationId).collection("messages").order(by: "timestamp", descending: false).getDocuments()
        
        
        return snapshot.documents.compactMap { document -> Message? in
              try? document.data(as: Message.self)
          }
      }
    
    func postMessage(conversationId: String, userId: String, message: Message) async throws {
          // Reference to the specific conversation's messages collection
          let messageRef = db.collection("users").document(userId).collection("conversations").document(conversationId).collection("messages")
          
          do {
              // Add a new document with a generated ID in the messages collection
              try messageRef.addDocument(from: message)
              print("Message successfully added")
          } catch {
              print("Error posting message: \(error)")
              throw error
          }
      }
}

//
//func getUser(userID: String) async throws -> DBUser {
//    
//    let snapshot = try await Firestore.firestore().collection("users").document(userID).getDocument()
//    
//    guard let data = snapshot.data(), let userID = data["user_id"] as? String else {
//        throw URLError(.badServerResponse)
//        
//    }
//    
//    let userId = data["user_id"] as? String
//    let email = data["email"] as? String
//    let phoneNumber = data["phone_number"] as? String
//    let photoUrl = data["photo_url"] as? String
//    let dateCreated = data["date_created"] as? Date
//    let firstName = data["first_name"] as? String
//    let surname = data["surname"] as? String
//    let city = data["city"] as? String
//    
//    
//    return DBUser(userId: userID, email: email, phoneNumber: phoneNumber, photoUrl: photoUrl, dateCreated: dateCreated, firstName: firstName, surname: surname, city: city)
//    
//}
