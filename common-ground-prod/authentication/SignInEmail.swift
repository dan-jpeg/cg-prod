//
//  SignInEmail.swift
//  common-ground
//
//  Created by dan crowley on 3/11/24.
//

import SwiftUI

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var authID = ""
    
    func signUp() async throws  {
        guard !email.isEmpty, !password.isEmpty else {
            print("no email")
            return
        }
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        try await UserManager.shared.createNewUser(auth: authDataResult)
        
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("no email / pw found")
            return
        }
        
        let authDataResult = try await AuthenticationManager.shared.signInUser(email: email, password: password)
        try await UserManager.shared.createNewUser(auth: authDataResult)
       
    }
}



struct SignInEmailView: View {
    
    var namespace: Namespace.ID
   
    @State private var signUpView: Bool = false
    
    @State private var isOnboarding: Bool = false
    
    @StateObject private var viewModel = SignInEmailViewModel()
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        VStack {
            HStack(spacing: 40) {
                LogoView(size: 60, namespace: namespace)
                LogoTextView(namespace: namespace)
            }
            VStack(alignment: .leading) {
                
            
                
                VStack {
                    CustomTextField(icon: "none", placeHolder: "EM", text: $viewModel.email, isSecure: false)
                        .textInputAutocapitalization(.never)
                        .padding()
                    
                    Divider()
                    CustomTextField(icon: "none", placeHolder: "PW", text: $viewModel.password, isSecure: true)
                        
                        
                }
                HStack {
                    Spacer()
                    HStack(alignment: .center) {
                        if signUpView {
                            Text("SIGN IN")
                            .matchedGeometryEffect(id: "signUp", in: namespace)
                            .opacity(0.2)
                            .onTapGesture {
                                signUpView.toggle()
                            }
                            Spacer()
                            Text("SIGN UP")
                            .matchedGeometryEffect(id: "signIn", in: namespace)
                            .onTapGesture {
                                Task {
                                    do {
                                        try await viewModel.signUp()
                                        isOnboarding = true
                                       
                                        return
                                    } catch {
                                        print(error)
                                    }
                                    
//                                    do {
//                                        try await viewModel.signIn()
//                                        viewState = .authenticated
//                                        return
//                                    } catch {
//                                        print(error)
//                                    }
                                }
                            }
                        } else {
                          
                            Text(signUpView ? "SIGN UP" : "SIGN UP?")
                                .matchedGeometryEffect(id: "signIn", in: namespace)
                                .opacity(0.2)
                                .onTapGesture {
                                    signUpView.toggle()
                                }
                           Spacer()
                            Text(signUpView ? "SIGN IN?" : "SIGN IN")
                                .matchedGeometryEffect(id: "signUp", in: namespace)
                                .onTapGesture {
                                    Task {
//                                        do {
//                                            try await viewModel.signUp()
//                                            viewState = .authenticated
//                                            return
//                                        } catch {
//                                            print(error)
//                                        }
                                        
                                        do {
                                            try await viewModel.signIn()
                                            navigationManager.appState = .authenticated
                                            return
                                        } catch {
                                            print(error)
                                        }
                                    }
                                }
                        }

                    }
                 
                }
                .fontWeight(.semibold)
                .font(.system(size: 22))
                .padding(.top, 10)
            }
            
       
            Spacer()
        }
        .animation(.easeInOut(duration: 0.6), value: signUpView)
        .fullScreenCover(isPresented: $isOnboarding) {
            OnboardingView(isOnboarding: $isOnboarding)
        }
        .padding(.horizontal, 40)
    }
    
}

