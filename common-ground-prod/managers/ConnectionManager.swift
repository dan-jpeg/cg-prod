//
//  ConnectionManager.swift
//  common-ground-prod
//
//  Created by dan crowley on 4/6/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift



final class ConnectionManager {
    
    static let shared = ConnectionManager()
    private init() { }
    private let db = Firestore.firestore()
    
    func createConnection(userId1: String, userId2: String) async throws {
        var connectionId: String?
        
        let connection = Connection(
            userId1: userId1,
            userId2: userId2,
            connectionRevealed: false,
            dateCreated: Date(),
            dateRevealed: Date(timeIntervalSince1970: 0), // Placeholder for future reveal date
            hidden: false
        )
        
        do {
            // Attempt to add a new connection document to the 'connections' collection.
            let connection = try db.collection("connections").addDocument(from: connection)
            connectionId = connection.documentID
            
            print("Connection \(connectionId) successfully created")
        } catch let error {
            print("Error creating connection: \(error)")
            throw error
        }
        
        let userDocRef1 = db.collection("users").document(userId1)
        let userDocRef2 = db.collection("users").document(userId2)
        
        
        // Use async/await within the loop for asynchronous updates
        if let connectionId = connectionId {
            Task {
                for userDocRef in [userDocRef1, userDocRef2] {
                    try await userDocRef.updateData([
                        "connections": FieldValue.arrayUnion([connectionId])
                    ])
                }
            }
            
            print("Connection successfully created and user connections updated")
            
        } else { print("error: problem setting user connections array")}
        
    }
    
    
    func fetchConnectionIdArrayWithUserId(userId: String) async throws -> [String] {
        
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        
        print(userId)
            
        guard let data = snapshot.data(), let userID = data["user_id"] as? String else {
            throw URLError(.badServerResponse)
            
        }
        
        guard var connectionIds = data["connections"] as? [String] else { return ["no connections"]}
        
         
        connectionIds.removeFirst()
        
        return connectionIds
        
    }
    
    func fetchConnections(connectionIDs: [String]) async throws -> [Connection] {
        
        var connections: [Connection] = []
        
        for connectionID in connectionIDs {
            let snapshot = try await Firestore.firestore().collection("connections").document(connectionID).getDocument()
            
            if let connection = try snapshot.data(as: Connection?.self){
                connections.append(connection)
            } else {
                print("Document does not exist or failed to decode for ID: \(connectionID)")
            }
            
            
        }
        
        
        return connections
        
    }
    
        
    
      func getUser(userID: String) async throws -> DBUser {
        
        let snapshot = try await Firestore.firestore().collection("users").document(userID).getDocument()
        
        guard let data = snapshot.data(), let userID = data["user_id"] as? String else {
            throw URLError(.badServerResponse)
            
        }
        
        
        let email = data["email"] as? String
        let phoneNumber = data["phone_number"] as? String
        let photoUrl = data["photo_url"] as? String
        let dateCreated = data["date_created"] as? Date
        let firstName = data["first_name"] as? String
        let surname = data["surname"] as? String
        let city = data["city"] as? String
        
        return DBUser(userId: userID, email: email, phoneNumber: phoneNumber, photoUrl: photoUrl, dateCreated: dateCreated, firstName: firstName, surname: surname, city: city)
        
    }
    
    func getConnectedUser(userID: String) async throws -> ConnectedUser {
        
        let snapshot = try await Firestore.firestore().collection("users").document(userID).getDocument()
        
        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        print("hello")
        let firstName = data["first_name"] as? String
        let surname = data["surname"] as? String
        let city = data["city"] as? String
        
    
        
        return ConnectedUser(id: userId, firstName: firstName, surname: surname, city: city)
    }
}

struct ConnectedUser: Identifiable {
    let id: String
    let firstName: String?
    let surname: String?
    let city: String?
}

