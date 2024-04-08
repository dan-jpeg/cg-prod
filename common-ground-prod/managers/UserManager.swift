//
//  UserManager.swift
//  common-ground-prod
//
//  Created by dan crowley on 3/17/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct OnboardingDataModel {
    let firstName: String
    let surname: String?
    let phoneNumber: String
    let city: String
}


struct DBUser {
    let userId: String
    let email: String?
    let phoneNumber: String?
    let photoUrl: String?
    let dateCreated: Date?
    let firstName: String?
    let surname: String?
    var city: String?
}



final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    
    
    func createNewUser(auth: AuthDataResultModel) async throws {
        
        var userData: [String:Any] = [
            "user_id": auth.uid,
            "date_created": Timestamp()
            ]
        
        if let email = auth.email {
            userData["email"] = email
        }
        
        if let photoUrl = auth.photoUrl {
            userData["photo_url"] = photoUrl
        }
    
        
        
        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData)
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
    
    func uploadOnboardingData(userId: String, onboardingData: OnboardingDataModel) async throws -> DBUser {
        

        let db = Firestore.firestore()
        
        
        var userData: [String: Any] = [
            "first_name": onboardingData.firstName,
            "phone_number": onboardingData.phoneNumber,
            "city": onboardingData.city
        ]
        
        if let surname = onboardingData.surname {
                userData["surname"] = surname
            }
        
        try await db.collection("users").document(userId).updateData(userData)

           return try await getUser(userID: userId)
       
    }
        
    
    func fetchAllUsers() async throws -> [DBUser]{
        let querySnapshot = try await Firestore.firestore().collection("users").getDocuments()
        var users: [DBUser] = []
        
        for document in querySnapshot.documents {
                   let data = document.data()
                   let userId = data["user_id"] as? String ?? ""
                   let email = data["email"] as? String
                   let phoneNumber = data["phone_number"] as? String
                   let photoUrl = data["photo_url"] as? String
                   let dateCreated = (data["date_created"] as? Timestamp)?.dateValue()
                   let firstName = data["first_name"] as? String
                   let surname = data["surname"] as? String
                   let city = data["city"] as? String
                   
                   let user = DBUser(userId: userId, email: email, phoneNumber: phoneNumber, photoUrl: photoUrl, dateCreated: dateCreated, firstName: firstName, surname: surname, city: city)
                   users.append(user)
               }
               
               return users
           }
        
}

