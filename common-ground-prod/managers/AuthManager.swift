    //
    //  AuthManager.swift
    //  common-ground
    //
    //  Created by dan crowley on 3/11/24.
    //

    import Foundation
    import FirebaseAuth

    struct AuthDataResultModel {
        let uid: String
        let email: String?
        let photoUrl: String?
        
        
        init(user: User) {
            self.uid = user.uid
            self.email = user.email
            self.photoUrl = user.photoURL?.absoluteString
        }
        
    }



    final class AuthenticationManager {
        static let shared = AuthenticationManager()
        private init() { }
        
        func getAuthenticatedUser() throws -> AuthDataResultModel {
            guard let user = Auth.auth().currentUser else {
                throw URLError(.badServerResponse)
            }
            return AuthDataResultModel(user: user)
        }
        
        @discardableResult
        func createUser(email: String, password: String) async throws -> AuthDataResultModel {
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            print("signed up successfully. uid: \(authDataResult.user.uid)")
            return AuthDataResultModel(user: authDataResult.user)
        }
        
        @discardableResult
        func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
            let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
            print("signed in successfully.  uid: \(authDataResult.user.uid)")
            
            return AuthDataResultModel(user: authDataResult.user)
            
        }
        func signOut() throws {
           try Auth.auth().signOut()
            print("user signed out")
        }
        
        func resetPassword(email: String) async throws {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            
        }
        
        func updatePassword(password: String) async throws {
            guard let user = Auth.auth().currentUser else {
                throw URLError(.badServerResponse)
            }
            
            try await user.updatePassword(to: password)
        }
        
        
    }
