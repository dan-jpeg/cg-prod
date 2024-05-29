//
//  SettingsOptionsView.swift
//  common-ground-prod
//
//  Created by dan crowley on 3/17/24.
//

import SwiftUI

struct SettingsOptionsView: View {
    
    var namespace: Namespace.ID
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack(spacing:20) {
            Spacer()
            LogoView(size: 44, namespace: namespace)
            LogoTextView(namespace: namespace)
            Spacer()
            Button("Log out") {
                Task {
                    do {
                        try viewModel.signOut()
                        
                    } catch {
                        print(error)
                    }
                }
            }
            Button("reset password") {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("pw reset")
                    }
                    catch {
                        print(error)
                    }
                }
            }
        }

    }
}

