//
//  RootView2.swift
//  common-ground-prod
//
//  Created by dan crowley on 3/15/24.
//

import SwiftUI

enum AuthViewState {
    case notYetTapped
    case signInView
    case authenticated
}

final class NavigationManager: ObservableObject {
    
    enum AppState {
        case notYetTapped
        case notAuthenticated
        case authenticated
    }
    
    @Published var appState: AppState = .authenticated
}


struct RootView: View {
    
  
    @StateObject var navigationManager = NavigationManager()
    
    @Namespace private var namespace
    
    var body: some View {
        VStack {
            switch navigationManager.appState {
            case .notYetTapped:
                TapAnyWhereView(namespace: namespace)
                    .environmentObject(navigationManager)
            case .notAuthenticated:
                SignInEmailView(namespace: namespace)
                    .environmentObject(navigationManager)
            case .authenticated:
                // Navigate to the authenticated part of your app
                HomeView(namespace: namespace)
                    .environmentObject(navigationManager)
                    
            }
        }
        .onAppear {
                        let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            if authUser == nil {
                navigationManager.appState = .notYetTapped
            }
                        
                    }
        
    }
}
#Preview {
    RootView()
}
