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


extension OnboardingViewModel: NameValidationProtocol, DateOfBirthValidationProtocol, PhoneNumberValidationProtocol, CityValidationProtocol {
    var isNameValid: Bool {
        return !firstName.isEmpty && !surname.isEmpty
    }

    var isDateOfBirthValid: Bool {
        // Assuming YYYY format for simplicity
        return dateOfBirth.count == 4 && Int(dateOfBirth) != nil
    }

    var isPhoneNumberValid: Bool {
        // Example: US standard phone number length without considering country code
        return phoneNumber.count == 10 && Int(phoneNumber) != nil
    }

    var isCityValid: Bool {
        return !city.isEmpty
    }
}

protocol NameValidationProtocol {
    var isNameValid: Bool { get }
}

protocol DateOfBirthValidationProtocol {
    var isDateOfBirthValid: Bool { get }
}

protocol PhoneNumberValidationProtocol {
    var isPhoneNumberValid: Bool { get }
}

protocol CityValidationProtocol {
    var isCityValid: Bool { get }
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
                if viewModel.errorMessage != "" {
                    Text(viewModel.errorMessage)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .textCase(.uppercase)
                }
                switch viewState {
                case .preTap:
                    Text("tap")
                        .asButton {
                            viewState = .name
                        }
                case .name:
                    
                    VStack(spacing: 20) {
                        CustomTextField(label: "person", placeHolder: "FIRST NAME", text: $viewModel.firstName, isSecure: false)
                        CustomTextField(label: "person", placeHolder: "LAST NAME", text: $viewModel.surname, isSecure: false)
                        
                        Text("->")
                            .asButton {
                                if viewModel.isNameValid {
                                    viewState = .dateOfBirth
                                    viewModel.errorMessage = ""
                                }
                                else {
                                    viewModel.errorMessage = "please enter a valid name"
                                }
                            }
                    }
                    
                    
                case .dateOfBirth:
                    VStack {
                        CustomTextField(label: "person", placeHolder: "WHAT YEAR WERE YOU BORN?", text: $viewModel.dateOfBirth, isSecure: false)
                        
                        Text("->")
                            .asButton {
                                if viewModel.isDateOfBirthValid {
                                    viewState = .phoneNumber
                                    viewModel.errorMessage = ""
                                } else {
                                    viewModel.errorMessage = "please enter a valid dob"
                                    
                                }
                               
                            }
                    }
                    
                case .phoneNumber:
                    VStack {
                        CustomTextField(label: "phone", placeHolder: "CAN WE HAVE YOUR NUMBER?", text: $viewModel.phoneNumber, isSecure: false)
                        Text("->")
                            .asButton {
                                if viewModel.isPhoneNumberValid {
                                    viewModel.errorMessage = ""
                                    viewState = .city
                                } else {
                                    viewModel.errorMessage = "please enter a valid phone number"
                                }
                            }
                    }
                case .city:
                    VStack {
                        CustomTextField(label: "phone", placeHolder: "CITY", text: $viewModel.city, isSecure: false)
                        Button("go") {
                            Task {
                                do {
                                    if viewModel.isCityValid {
                                        viewModel.errorMessage = ""
                                        try await viewModel.onboardUser()
                                        isOnboarding = false
                                        navigationManager.appState = .authenticated
                                    }
                                    else {
                                        viewModel.errorMessage = "please enter a valid city"
                                    }
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
