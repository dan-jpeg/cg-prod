//
//  AuthenticationView.swift
//  common-ground-prod
//
//  Created by dan crowley on 3/14/24.
//

import SwiftUI

enum AuthenticationViewState {
    case notYetTapped
    case loginView
}

struct TapAnyWhereView: View {
    
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    var namespace: Namespace.ID

    
    var body: some View {
        VStack {
            VStack {
                LogoTextView(namespace: namespace)
                LogoView(size: 100, namespace: namespace)
                MoonPhaseView()
                
            }
            .padding(.top, UIScreen.main.bounds.height/5)
            Spacer()
            Text("TAP ANYWHERE")
                .fontWeight(.bold)
                .padding(.bottom, UIScreen.main.bounds.height/5)
        }
        .onTapGesture {
            navigationManager.appState = .notAuthenticated
        }
    }
        
}

//struct AuthenticationView: View {
//    
//    @Binding var showSignInView: Bool
//    
//    @State private var viewState: AuthenticationViewState = .notYetTapped
//    
//    @Namespace var namespace
//    
//    var body: some View {
//        switch viewState {
//        case .notYetTapped:
//            TapAnyWhereView(showSignInView: $showSignInView)
//        case .loginView:
//            SignInEmailView(showSignInView: $showSignInView)
//        }
//    }
//}


//#Preview {
//    AuthenticationView(showSignInView: .constant(false))
//}
