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
        
    //    func fetchConversations(userId: String) async throws -> [Conversation] {
    //        let snapshot = try await db.collection("users").document(userId).collection("conversations").getDocuments()
    //
    //        for document in snapshot.documents {
    //            print("Document ID: \(document.documentID), Data: \(document.data())")
    //        }
    //
    //        return snapshot.documents.compactMap { document -> Conversation? in
    //            do {
    //                return try document.data(as: Conversation.self)
    //            } catch {
    //                print("Error decoding conversation: \(error)")
    //                return nil
    //            }
    //        }
    //
    //
    //    }
        
        func setUserTyping(conversationId: String, userId: String, isTyping: Bool) async throws {
            let conversationRef = db.collection("conversations").document(conversationId)
            try await conversationRef.updateData(["typing.\(userId)": isTyping])
        }
        
        func listenForTyping(conversationId: String, updateUI: @escaping (Result<[String: Bool], Error>) -> Void) {
            let conversationRef = db.collection("conversations").document(conversationId)
            conversationRef.addSnapshotListener { snapshot, error in
                if let error = error {
                    updateUI(.failure(error))
                    return
                }
                guard let data = snapshot?.data(), let typingStatus = data["typing"] as? [String: Bool] else {
                    updateUI(.failure(NSError(domain: "FirestoreError", code: -1, userInfo: ["message": "Data not found"])))
                    return
                }
                updateUI(.success(typingStatus))
            }
        }
        
        func fetchConversations(userId: String) async throws -> [Conversation] {
            // Query the 'conversations' collection for documents where 'participants' contains 'userId' as a key
            let querySnapshot = try await db.collection("conversations")
                .whereField("participants.\(userId)", isGreaterThan: "")
                .getDocuments()
            
            // Map each document to a 'Conversation' object
            let conversations = querySnapshot.documents.compactMap { document -> Conversation? in
                do {
                    return try document.data(as: Conversation.self)
                } catch {
                    print("Error decoding conversation: \(error)")
                    return nil
                }
            }
            
            return conversations
        }
        
    //    func fetchMessages(conversationId: String, userId: String) async throws -> [Message] {
    //        let snapshot = try await db.collection("users").document(userId).collection("conversations").document(conversationId).collection("messages").order(by: "timestamp", descending: false).getDocuments()
    //
    //
    //        return snapshot.documents.compactMap { document -> Message? in
    //              try? document.data(as: Message.self)
    //          }
    //      }
        
        func fetchMessages(conversationId: String) async throws -> [Message] {
              // Reference to the specific conversation's messages subcollection, ordered by timestamp
              let querySnapshot = try await db.collection("conversations").document(conversationId)
                  .collection("messages").order(by: "timestamp", descending: false).getDocuments()
                
              // Map each document to a 'Message' object
              let messages = querySnapshot.documents.compactMap { document -> Message? in
                  do {
                      return try document.data(as: Message.self)
                  } catch {
                      print("Error decoding message: \(error)")
                      return nil
                  }
              }
              
              return messages
          }
        
    //    func postMessage(conversationId: String, userId: String, message: Message) async throws {
    //          // Reference to the specific conversation's messages collection
    //          let messageRef = db.collection("users").document(userId).collection("conversations").document(conversationId).collection("messages")
    //
    //          do {
    //              // Add a new document with a generated ID in the messages collection
    //              try messageRef.addDocument(from: message)
    //              print("Message successfully added")
    //          } catch {
    //              print("Error posting message: \(error)")
    //              throw error
    //          }
    //      }
        
        func postMessage(conversationId: String, message: Message) async throws {
              // Reference to the specific conversation's messages subcollection
              let messageRef = db.collection("conversations").document(conversationId).collection("messages")
              do {
                  // Add a new document with a generated ID in the messages subcollection
                  _ = try messageRef.addDocument(from: message)
                  print("Message successfully added")
                  let conversationRef = db.collection("conversations").document(conversationId)
                  try await conversationRef.updateData([
                    "lastMessage" : message.text,
                    "lastMessageTimestamp" : message.timestamp
                  ])
              } catch {
                  print("Error posting message: \(error)")
                  throw error
              }
          }
      
        
        //takes an array of userIDs, userArray and creates a new conversation between the two
        func createConversation(userIDs: [String]) async throws -> Conversation {
            var participantsDict = [String: String]()
            
            for userID in userIDs {
                let displayName = try await getUserDisplayName(userID: userID)
                participantsDict[userID] = displayName
            }
            
            // Initialize the new conversation with the dictionary
            var newConversation = Conversation(participants: participantsDict, lastMessage: nil, lastMessageTimestamp: nil, lastRead: [:])
            
            // Set initial last read for each participant
            for userID in userIDs {
                newConversation.lastRead[userID] = Date()
            }

            let documentReference = try db.collection("conversations").addDocument(from: newConversation)
            let documentSnapshot = try await documentReference.getDocument()
            
            let conversationData = try documentSnapshot.data(as: Conversation.self)
            
            newConversation.id = documentSnapshot.documentID
            return newConversation
        }
        
        func toggleFavorite(for messageId: String, in conversationId: String, isFavorite: Bool) async throws {
            // Reference to the specific message document in the Firestore collection
            
            let messageRef = db.collection("conversations").document(conversationId).collection("messages").document(messageId)
            
            do {
                // Update the 'favorite' field of the specific message document
                try await messageRef.updateData([
                    "favorite": !isFavorite // Toggle the current state
                ])
                print("Message favorite status successfully updated")
            } catch {
                print("Error updating message favorite status: \(error)")
                throw error
            }
        }
     }

func getUserDisplayName(userID: String) async throws -> String {
    let snapshot = try await Firestore.firestore().collection("users").document(userID).getDocument()

    // Handle potential missing document or data gracefully
    guard let data = snapshot.data() else {
        throw MyCustomError.userDocumentNotFound(userID: userID) // Use a custom error type
    }

    // Extract user name and surname safely
    let name = data["first_name"] as? String ?? ""
    let surname = data["surname"] as? String ?? ""

    // Construct the full name with proper formatting
    let fullName = name.isEmpty ? surname : (name + " " + surname)

    return fullName.trimmingCharacters(in: .whitespacesAndNewlines) // Remove leading/trailing whitespace
}



// Define a custom error type for clarity (optional)
enum MyCustomError: Error {
    case userDocumentNotFound(userID: String)
}

    
    func getUser(userID: String) async throws -> DBUser {
    
        let snapshot = try await Firestore.firestore().collection("users").document(userID).getDocument()
    
        guard let data = snapshot.data(), let userID = data["user_id"] as? String else {
            throw URLError(.badServerResponse)
    
        }
    
        let userId = data["user_id"] as? String
        let email = data["email"] as? String
        let phoneNumber = data["phone_number"] as? String
        let photoUrl = data["photo_url"] as? String
        let dateCreated = data["date_created"] as? Date
        let firstName = data["first_name"] as? String
        let surname = data["surname"] as? String
        let city = data["city"] as? String
    
    
        return DBUser(userId: userID, email: email, phoneNumber: phoneNumber, photoUrl: photoUrl, dateCreated: dateCreated, firstName: firstName, surname: surname, city: city)
    
    }
