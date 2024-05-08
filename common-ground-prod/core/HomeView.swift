//
//  SettingsView.swift
//  common-ground-prod
//
//  Created by dan crowley on 3/14/24.
//

import SwiftUI
import SwiftfulUI

enum MenuState {
    case welcome
    case mapView
    case mapDetail
    case profileView
    case inboxView
}


@MainActor
final class HomeViewModel: ObservableObject {
    
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
            
        }
        
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    func signOut() throws {
        
    
        try AuthenticationManager.shared.signOut()
        
    }
    
}

struct HomeView: View {
    
    @State private var selectedSlice: String = " "
    @State private var isShowingSettings: Bool = false
    @State private var menuState: MenuState = .welcome
    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject private var viewModel = HomeViewModel()
    
    var namespace: Namespace.ID
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 30) // Set your desired corner radius here
                .stroke(borderColor.opacity(0.00), lineWidth: 2) // Set the color and line width of the border
                .background(RoundedRectangle(cornerRadius: 25).fill(Color.white))
            
                .padding(.init(top: 70, leading: 12, bottom: 20, trailing: 12))
                .ignoresSafeArea()
        VStack {
            switch menuState {
            case .welcome:
                VStack(spacing:20) {
                    Spacer()
                    LogoView(size: 60, namespace: namespace)
                        .onTapGesture {
                            withAnimation {
                                menuState = .inboxView
                            }
                        }
                    LogoTextView(namespace: namespace)
                        .onTapGesture {
                            withAnimation {
                                menuState = .mapView
                            }
                        }
                    Spacer()
                    VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "gear")
                            .font(.system(size: 12))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 6))
                            .rotationEffect(isShowingSettings ? Angle(degrees: 90) : .zero)
                        
                    }
                    .asButton(action: {
                        withAnimation(.smooth(duration: 0.8, extraBounce: 0.1)) {
                            isShowingSettings.toggle()
                        }
                    })
                    
                    if isShowingSettings {
                       
                            Button(action:  {
                                withAnimation {
                                    menuState = .profileView
                                }
                            }, label: {
                                Text("SETTINGS")
                            })
                            Button("Logout") {
                                Task {
                                    do {
                                        try viewModel.signOut()
                                        navigationManager.appState = .notYetTapped
                                    } catch {
                                        print(error)
                                    }
                                }
                            }
                            Button("reset \n password") {
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
                    }.foregroundStyle(.black)
                        .font(.system(size: 12, weight: .light, design: .rounded))
                        .padding(.bottom, 20)
                        .textCase(.uppercase)
                        .opacity(0.8)
                }.opacity(0.8)
                
            case .mapView:
                MenuView(namespace: namespace, menuState: $menuState, selectedSlice: $selectedSlice)
                
            case .mapDetail:
                let imageName: String =  "map" + selectedSlice
                MapDetailView(namespace: namespace, imageName: imageName , menuState: $menuState)
                
            case .profileView:
                
                ProfileView(namespace: namespace, menuState: $menuState)
            case .inboxView:
                InboxView2(menuState: $menuState, namespace: namespace)
            }
        }.animation(.smooth, value: menuState)
    }
}
}
//
//#Preview {
//    SettingsView(showSignInView: .constant(false))
//}
