import SwiftUI

struct ConnectionViewer: View {
    
    var height: CGFloat = 240
    var connectedUsers: [ConnectedUser] = ConnectedUser.mockData
    
    var body: some View {
        
        let groupedUsers = splitUsersIntoThreeGroups(connectedUsers)
        
        HStack(spacing: 4) {
            ForEach(groupedUsers.indices, id: \.self) { index in
                ScrollView(.vertical) {
                    VStack(spacing: 6) {
                        ForEach(groupedUsers[index]) { user in
                            Rectangle()
                                .fill(Color.gray.opacity(0.07))
                                .frame(width: 130, height: height)
                                .overlay(
                                    ConnectedUserInfo(user: user)
                                )
                        }
                    }
                    .padding(.zero)
                }
                .scrollIndicators(.hidden)
                .frame(maxWidth: .infinity)
            }
        }
        .ignoresSafeArea(.all)
    }
    
    func splitUsersIntoThreeGroups(_ users: [ConnectedUser]) -> [[ConnectedUser]] {
        var group1 = [ConnectedUser]()
        var group2 = [ConnectedUser]()
        var group3 = [ConnectedUser]()
        
        for (index, user) in users.enumerated() {
            if index % 3 == 0 {
                group1.append(user)
            } else if index % 3 == 1 {
                group2.append(user)
            } else {
                group3.append(user)
            }
        }
        
        return [group1, group2, group3]
    }
}

#Preview {
    ConnectionViewer()
}

struct ConnectedUserInfo: View {
    
    let sampleCities: [String] = ["nyc", "chicago", "miami", "boston", "london"]
    var user: ConnectedUser
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            let initials = "\(user.firstName?.first.map { String($0) } ?? "")\(user.surname?.first.map { String($0) } ?? "")"
            
            Text(initials)
                .font(.system(size: 66))
                .bold()
                .offset(x: -10)
            
            if let city = user.city {
                let cityIndex = city - 1
                let cityName = sampleCities[cityIndex]
                Text(cityName)
            }
            if let industry = user.industry {
                Text(industry)
                
            }
            
            if let ageRange = user.ageRange {
                Text(ageRange)
                
            }
            
            if let hobbies = user.hobbies {
                Text("Hobbies: \(hobbies.joined(separator: ", "))")
            }
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 44)
    }
}
