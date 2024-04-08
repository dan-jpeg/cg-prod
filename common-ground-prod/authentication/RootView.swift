//
//  RootView.swift
//  common-ground-prod
//
//  Created by dan crowley on 3/14/24.
//
//
//import SwiftUI
//
//struct RootView: View {
//    
//    
//    @State private var showSignInView: Bool = false
//    
//    var body: some View {
//        ZStack {
//            NavigationStack{
//                SettingsView(showSignInView: $showSignInView)
//            }
//        }
//        .onAppear {
//            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
//            self.showSignInView = authUser == nil ? true : false
//        }
//        
//        .fullScreenCover(isPresented: $showSignInView) {
//            NavigationStack {
//                AuthenticationView(showSignInView: $showSignInView)
//            }
//        }
//    }
//}
//
//#Preview {
//    RootView()
//}
