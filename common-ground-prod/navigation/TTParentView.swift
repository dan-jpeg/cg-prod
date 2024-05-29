import SwiftUI
import Combine

class UserViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var phoneNumber: String = ""
    @Published var hometown: String = ""
    @Published var currentCity: String = ""
    @Published var activityOne: String = ""
    @Published var activityTwo: String = ""
    @Published var currentlyEditing: String?
}

struct ProfileParentView: View {
    @StateObject private var viewModel = UserViewModel()

    var body: some View {
        VStack {
            // Business Card View
            BusinessCardView(viewModel: viewModel)
                .padding()

            // Form for editing user information
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("First Name", text: $viewModel.firstName, onEditingChanged: { isEditing in
                        viewModel.currentlyEditing = isEditing ? "firstName" : nil
                    })
                    TextField("Last Name", text: $viewModel.lastName, onEditingChanged: { isEditing in
                        viewModel.currentlyEditing = isEditing ? "lastName" : nil
                    })
                    TextField("Phone Number", text: $viewModel.phoneNumber, onEditingChanged: { isEditing in
                        viewModel.currentlyEditing = isEditing ? "phoneNumber" : nil
                    })
                    TextField("Hometown", text: $viewModel.hometown, onEditingChanged: { isEditing in
                        viewModel.currentlyEditing = isEditing ? "hometown" : nil
                    })
                    TextField("Current City", text: $viewModel.currentCity, onEditingChanged: { isEditing in
                        viewModel.currentlyEditing = isEditing ? "currentCity" : nil
                    })
                }

                Section(header: Text("Activities")) {
                    TextField("Activity One", text: $viewModel.activityOne, onEditingChanged: { isEditing in
                        viewModel.currentlyEditing = isEditing ? "activityOne" : nil
                    })
                    TextField("Activity Two", text: $viewModel.activityTwo, onEditingChanged: { isEditing in
                        viewModel.currentlyEditing = isEditing ? "activityTwo" : nil
                    })
                }
            }
        }
        .navigationTitle("User Profile")
    }
}

struct BusinessCardView: View {
    @ObservedObject var viewModel: UserViewModel

    var body: some View {
        VStack(alignment: .leading) {
            if viewModel.currentlyEditing == nil || viewModel.currentlyEditing == "firstName" {
                Text(viewModel.firstName)
                    .font(.title)
                    .fontWeight(viewModel.currentlyEditing == "firstName" ? .bold : .regular)
                    .animation(.easeInOut)
            }
            if viewModel.currentlyEditing == nil || viewModel.currentlyEditing == "lastName" {
                Text(viewModel.lastName)
                    .font(.title)
                    .fontWeight(viewModel.currentlyEditing == "lastName" ? .bold : .regular)
                    .animation(.easeInOut)
            }
            if viewModel.currentlyEditing == nil || viewModel.currentlyEditing == "phoneNumber" {
                Text(viewModel.phoneNumber)
                    .font(.subheadline)
                    .fontWeight(viewModel.currentlyEditing == "phoneNumber" ? .bold : .regular)
                    .animation(.easeInOut)
            }
            if viewModel.currentlyEditing == nil || viewModel.currentlyEditing == "hometown" {
                Text("From: \(viewModel.hometown)")
                    .font(.subheadline)
                    .fontWeight(viewModel.currentlyEditing == "hometown" ? .bold : .regular)
                    .animation(.easeInOut)
            }
            if viewModel.currentlyEditing == nil || viewModel.currentlyEditing == "currentCity" {
                Text("Lives in: \(viewModel.currentCity)")
                    .font(.subheadline)
                    .fontWeight(viewModel.currentlyEditing == "currentCity" ? .bold : .regular)
                    .animation(.easeInOut)
            }
            if viewModel.currentlyEditing == nil || viewModel.currentlyEditing == "activityOne" || viewModel.currentlyEditing == "activityTwo" {
                HStack {
                    Text("Activities: ")
                    if viewModel.currentlyEditing == nil || viewModel.currentlyEditing == "activityOne" {
                        Text(viewModel.activityOne)
                            .fontWeight(viewModel.currentlyEditing == "activityOne" ? .bold : .regular)
                            .animation(.easeInOut)
                    }
                    if viewModel.currentlyEditing == nil || viewModel.currentlyEditing == "activityTwo" {
                        Text(viewModel.activityTwo)
                            .fontWeight(viewModel.currentlyEditing == "activityTwo" ? .bold : .regular)
                            .animation(.easeInOut)
                    }
                }
                .font(.subheadline)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .scaleEffect(viewModel.currentlyEditing == nil ? 1.0 : 1.1)
        .animation(.easeInOut)
    }
}

#Preview {
    ProfileParentView()
}
