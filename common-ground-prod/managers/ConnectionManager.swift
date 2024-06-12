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
        
        guard var connectionIds = data["connections"] as? [String] else { return ["connections:","no connections"]}
        
         
        
        print(connectionIds)
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
//        let city = data["city"] as? String
        let cities = [1, 2, 3, 4, 5]
        let industries = ["finance", "real estate", "tech", "service", "design", "art"]
        let hobbies = ["climbing", "hiking", "crypto", "music", "clubbing", "racket", "art"]
//wandom industry out of finance, real estate, tech, service, design, or art
        let ageRange: String = "25-34" //
        
        let randomCity = cities.randomElement() ?? 1
        let randomIndustry = industries.randomElement() ?? "industry"
        let randomHobbies = hobbies.shuffled().prefix(2).map { $0 }
        
        
        
        return ConnectedUser(id: userId, firstName: firstName, surname: surname, city: randomCity, industry: randomIndustry, ageRange: ageRange, hobbies: randomHobbies)
    }
}

struct ConnectedUser: Identifiable {
    let id: String
    let firstName: String?
    let surname: String?
    let city: Int?
    let industry: String?
    let ageRange: String?
    let hobbies: [String]?
    
    static let mockData: [ConnectedUser] = {
        let hobbiesList = ["climbing", "hiking", "crypto", "music", "clubbing", "racket", "art", "sports", "cooking", "reading", "gaming", "horticulture", "painting", "traveling", "birding", "running", "drawing", "coding", "games", "sewing", "skiing", "wine tasting"]
        
        func getRandomHobbies() -> [String] {
            let numberOfHobbies = Int.random(in: 1...2)
            return Array(hobbiesList.shuffled().prefix(numberOfHobbies))
        }
        
        return [
            ConnectedUser(id: "1", firstName: "Alice", surname: "Smith", city: 1, industry: "tech", ageRange: "25-34", hobbies: getRandomHobbies()),
            ConnectedUser(id: "2", firstName: "Jinni", surname: "Xu", city: 2, industry: "design", ageRange: "35-44", hobbies: getRandomHobbies()),
            ConnectedUser(id: "3", firstName: "Case", surname: "Resor", city: 3, industry: "service", ageRange: "18-24", hobbies: getRandomHobbies()),
            ConnectedUser(id: 
                            "4", firstName: "Daniel", surname: "Crowley", city: 4, industry: "tech", ageRange: "45-54", hobbies: getRandomHobbies()),
            ConnectedUser(id: "5", firstName: "Mike", surname: "Stuzzi", city: 5, industry: "management", ageRange: "55+", hobbies: getRandomHobbies()),
            ConnectedUser(id: "6", firstName: "Sarah", surname: "Johnson", city: 1, industry: "finance", ageRange: "25-34", hobbies: getRandomHobbies()),
            ConnectedUser(id: "7", firstName: "Tom", surname: "Henderson", city: 2, industry: "real estate", ageRange: "35-44", hobbies: getRandomHobbies()),
            ConnectedUser(id: "8", firstName: "Emily", surname: "Davis", city: 3, industry: "tech", ageRange: "18-24", hobbies: getRandomHobbies()),
            ConnectedUser(id: "9", firstName: "Michael", surname: "Brown", city: 4, industry: "service", ageRange: "45-54", hobbies: getRandomHobbies()),
            ConnectedUser(id: "10", firstName: "Jessica", surname: "Williams", city: 5, industry: "design", ageRange: "55+", hobbies: getRandomHobbies()),
            ConnectedUser(id: "11", firstName: "David", surname: "Taylor", city: 1, industry: "art", ageRange: "25-34", hobbies: getRandomHobbies()),
            ConnectedUser(id: "12", firstName: "Laura", surname: "Martinez", city: 2, industry: "tech", ageRange: "35-44", hobbies: getRandomHobbies()),
            ConnectedUser(id: "13", firstName: "James", surname: "Anderson", city: 3, industry: "real estate", ageRange: "18-24", hobbies: getRandomHobbies()),
            ConnectedUser(id: "14", firstName: "Linda", surname: "Thomas", city: 4, industry: "finance", ageRange: "45-54", hobbies: getRandomHobbies()),
            ConnectedUser(id: "15", firstName: "Robert", surname: "Jackson", city: 5, industry: "service", ageRange: "55+", hobbies: getRandomHobbies()),
            ConnectedUser(id: "16", firstName: "Karen", surname: "Lee", city: 1, industry: "tech", ageRange: "25-34", hobbies: getRandomHobbies()),
            ConnectedUser(id: "17", firstName: "Steven", surname: "Harris", city: 2, industry: "design", ageRange: "35-44", hobbies: getRandomHobbies()),
            ConnectedUser(id: "18", firstName: "Susan", surname: "Clark", city: 3, industry: "art", ageRange: "18-24", hobbies: getRandomHobbies()),
            ConnectedUser(id: "19", firstName: "Christopher", surname: "Lewis", city: 4, industry: "real estate", ageRange: "45-54", hobbies: getRandomHobbies()),
            ConnectedUser(id: "20", firstName: "Patricia", surname: "Robinson", city: 5, industry: "finance", ageRange: "55+", hobbies: getRandomHobbies())
        ]
    }()
}

