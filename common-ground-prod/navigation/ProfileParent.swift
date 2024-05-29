//
//  ProfileParent.swift
//  common-ground-prod
//
//  Created by dan crowley on 5/20/24.
//

import SwiftUI

struct ProfileParent: View {
    
    var user: DBUser = .mock
    var body: some View {
        ScrollViewProfile(user: user)
    }
}

#Preview {
    ProfileParent()
}
