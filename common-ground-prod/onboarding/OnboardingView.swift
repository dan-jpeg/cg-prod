//
//  OnboardingView.swift
//  common-ground-prod
//
//  Created by dan crowley on 3/18/24.
//

import SwiftUI
import SwiftfulUI


@MainActor
final class OnboardingViewModel: ObservableObject {
    
    @Published var firstName = ""
    @Published var surname = ""
    @Published var dateOfBirth = ""
    @Published var city = ""
    @Published var phoneNumber = ""
    @Published var contacts = ""
    @Published var errorMessage: String = ""
    
    
        
    
    
    func onboardUser() async throws {
        guard !dateOfBirth.isEmpty, !city.isEmpty, !phoneNumber.isEmpty else {
            print("incomplete form")
            return
        }
        
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        let userId = authUser.uid
       
        
        let onboardingData = OnboardingDataModel(firstName: firstName, surname: surname, phoneNumber: phoneNumber, city: city)
        
            // Attempt to upload onboarding data
            do {
                let dbUser = try await UserManager.shared.uploadOnboardingData(userId: userId, onboardingData: onboardingData)
                // On successful onboarding, you might want to navigate the user to another view
                // Use dbUser as needed
                print("Onboarding successful for user: \(dbUser.userId)")
            } catch {
                // Handle and display any errors during the onboarding process
                self.errorMessage = "Failed to complete onboarding. Please try again."
                print(error.localizedDescription)
            }
    }
}

enum OnboardingViewState {
    case preTap
    case name
    case dateOfBirth
    case city
    case phoneNumber
}

enum OnboardingField {
    case firstname
    case lastname
    case city
    case dateofBirth
    case phoneNumber
}


struct OnboardingView: View {
    
    @FocusState private var fieldInFocus: OnboardingViewState?
    
    @Binding var isOnboarding: Bool
    
    @State private var viewState: OnboardingViewState = .preTap
    @StateObject private var viewModel = OnboardingViewModel()
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        VStack {
            Image("onboardingImage")
                .resizable()
                .frame(width: 200, height: 120)
                .padding(.bottom, 50)
            VStack(spacing: 40) {
                
                switch viewState {
                case .preTap:
                    Text("tap")
                        .asButton {
                            viewState = .name
                        }
                case .name:
                    
                    VStack(spacing: 20) {
                        CustomTextField(icon: "person", placeHolder: "FIRST NAME", text: $viewModel.firstName, isSecure: false)
                        CustomTextField(icon: "person", placeHolder: "LAST NAME", text: $viewModel.surname, isSecure: false)
                        
                        Text("->")
                            .asButton {
                                viewState = .dateOfBirth
                            }
                    }
                    
                    
                case .dateOfBirth:
                    VStack {
                        CustomTextField(icon: "person", placeHolder: "WHAT YEAR WERE YOU BORN?", text: $viewModel.dateOfBirth, isSecure: false)
                        
                        Text("->")
                            .asButton {
                                viewState = .phoneNumber
                            }
                    }
                    
                case .phoneNumber:
                    VStack {
                        CustomTextField(icon: "phone", placeHolder: "CAN WE HAVE YOUR NUMBER?", text: $viewModel.phoneNumber, isSecure: false)
                        Text("->")
                            .asButton {
                                viewState = .city
                            }
                    }
                case .city:
                    VStack {
                        CustomTextField(icon: "phone", placeHolder: "CITY", text: $viewModel.city, isSecure: false)
                        Button("go") {
                            Task {
                                do {
                                    try await viewModel.onboardUser()
                                    isOnboarding = false
                                    navigationManager.appState = .authenticated
                                }
                                catch {
                                    print("error posting")
                                }
                                
                            }
                        }.font(.system(size: 60))
                            .foregroundStyle(.gray)
                    }
                }
                    
                
              Spacer()
            }
        }.padding()
    }
}


#Preview {
    OnboardingView(isOnboarding: .constant(true))
}
