//
//  SignInEmail.swift
//  common-ground
//
//  Created by dan crowley on 3/11/24.
//

import SwiftUI




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
                    CustomTextField(label: "none", placeHolder: "EM", text: $viewModel.email, isSecure: false)
                        .textInputAutocapitalization(.never)
                        .padding()
                    
                    Divider()
                    CustomTextField(label: "none", placeHolder: "PW", text: $viewModel.password, isSecure: true)
                        
                        
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
                                        try await signUpSequence()
                                    } catch {
                                        print(error)
                                    }
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
                                        do {
                                            try await viewModel.signIn()
                                            print("in sign in")
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
    
    private func signUpSequence() async throws {
        
        
            try await viewModel.signUp()
        
        isOnboarding = true
        return
    }
    
}

struct signupButtons: View {
    var body: some View {
        HStack {
            Text("Welcome back.")
            
            Text("")
            
        }
        .frame(maxWidth: .infinity)
    }
}


struct SignInEmail_Previews: PreviewProvider {

    @Namespace private static var namespace // Define the shared namespace
    
    static var previews: some View {
        SignInEmailView(namespace: namespace)
    }
}


