//
//  Connection.swift
//  common-ground-prod
//
//  Created by dan crowley on 4/5/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Connection: Codable, Identifiable {
    
    @DocumentID var id: String?
    let userId1: String
    let userId2: String
    let connectionRevealed: Bool
    let dateCreated: Date
    let dateRevealed: Date
    let hidden: Bool

}
