//
//  NewIntro.swift
//  common-ground-prod
//
//  Created by dan crowley on 6/1/24.
//

import SwiftUI

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var authID = ""
    @Published var errorMessage: String? = nil
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password cannot be empty."
            return
        }
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        try await UserManager.shared.createNewUser(auth: authDataResult)
    }
    
    func signIn() async throws -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password cannot be empty."
            return false
        }
        
        do {
            let authDataResult = try await AuthenticationManager.shared.signInUser(email: email, password: password)
            try await AuthenticationManager.shared.signInUser(email: self.email, password: self.password)
            errorMessage = nil
            return true
        } catch {
            errorMessage = "Failed to sign in: \(error.localizedDescription)"
            return false
        }
    }
}

struct ArrowLogin: View {
    @State private var scrollOffset = CGFloat.zero
    @State private var isShowingSignUpView: Bool = false
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isOnboarding: Bool = false
    
    @StateObject private var viewModel = SignInEmailViewModel()
    @EnvironmentObject var navigationManager: NavigationManager
    
    var onSignInPress: (()-> Void)? = nil
    var onRegisterPress: (()-> Void)? = nil
    
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            ObservableScrollView(scrollOffset: $scrollOffset) { proxy in
                VStack {
                    Image("downArrow")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width-80, height: UIScreen.main.bounds.height/1.8)
                        .padding(.vertical, 48)
                        .padding(.bottom, 220)
                        .opacity(0.8)
                    HStack {
                        Text("common")
                        if scrollOffset < 150 {
                            Spacer()
                        }
                       
                        Text("ground")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 36)
                    
                
                    VStack(spacing: 12) {
                            if scrollOffset > 300 {
                                CustomTextField(label: "em", placeHolder: "real@email.com", text: $viewModel.email, isSecure: false)
                                    .textInputAutocapitalization(.never)
                                    .padding()
                                CustomTextField(label: "pw", placeHolder: "securePassword123", text: $viewModel.password, isSecure: true)
                                    .textInputAutocapitalization(.never)
                                    .padding()
                                HStack {
                                    Text("register?")
                                        .foregroundStyle(Color.gray.opacity(0.5))
                                        .onTapGesture {
                                            withAnimation(.smooth) {
                                                isShowingSignUpView = true
                                            }
                                        }
                                    Text("sign in")
                                        .onTapGesture {
                                            Task {
                                                do {
                                                    let success = try await viewModel.signIn()
                                                    if success {
                                                        print("sign in successful")
                                                        navigationManager.appState = .authenticated
                                                    } else {
                                                        print("sign in failed")
                                                    }
                                                } catch {
                                                    print(error)
                                                }
                                            }
                                        }

                                }
                            }
                            
                            Color.clear
                                .frame(height: 300)
                        
                    }
                    .offset(x: isShowingSignUpView ? -400 : 0)
                        .padding(.top, 48)

                }
            }
            .ignoresSafeArea(.all)
        .animation(.smooth, value: scrollOffset)
            VStack(spacing: 12) {
                    if scrollOffset > 400 {
                        CustomTextField(label: "e", placeHolder: "email", text: $viewModel.email, isSecure: false)
                            .textInputAutocapitalization(.never)
                            .padding()
                        CustomTextField(label: "p", placeHolder: "password", text: $viewModel.password, isSecure: true)
                            .textInputAutocapitalization(.never)
                            
                            .padding()
                            
                        HStack {
                            Text("already have an account?")
                                .foregroundStyle(Color.gray.opacity(0.5))
                                .onTapGesture {
                                    withAnimation(.smooth) {
                                        isShowingSignUpView.toggle()
                                    }
                                }
                            Text("register")
                                .onTapGesture {
                                    Task {
                                        do {
                                            try await signUpSequence()
                                        } catch {
                                            print(error)
                                        }
                                    }
//                                    onRegisterPress?() 
                                }
                        }
                    }
                    
                    Color.clear
                        .frame(height: 300)
                
            }
            .offset(x: isShowingSignUpView ? 0 : 450, y: 40)
                .padding(.top, 48)
                .onChange(of: scrollOffset) { oldValue, newValue in
                    if newValue < 530 {
                        withAnimation(.smooth) {
                            isShowingSignUpView = false
                        }
                    }
                }
            if let errorMessage = viewModel.errorMessage {
                            VStack {
                                Spacer()
                                Text(errorMessage)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.red)
                                    .cornerRadius(8)
                                    .padding()
                            }
                            .transition(.opacity)
                            .animation(.easeInOut, value: viewModel.errorMessage)
                            .allowsHitTesting(false)
                        }
        }
        .fullScreenCover(isPresented: $isOnboarding) {
            OnboardingView(isOnboarding: $isOnboarding)
        }
    }
    
    private func signUpSequence() async throws {
        
        
            try await viewModel.signUp()
        
        isOnboarding = true
        return
    }
}

#Preview {
    ArrowLogin()
}
