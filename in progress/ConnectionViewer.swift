import SwiftUI

struct ConnectionViewer: View {
    
    var height: CGFloat = 240
    var connectedUsers: [ConnectedUser] = ConnectedUser.mockData
    
    @State private var isShowingSelected: Bool = false
    
    // Array of offsets for each scroll view
    @State private var offsets: [CGFloat] = [0, 100, 200]
    
    var body: some View {
        
        let groupedUsers = splitUsersIntoThreeGroups(connectedUsers)
        
        HStack(spacing: 3) {
            ForEach(groupedUsers.indices, id: \.self) { index in
                ScrollViewReader { scrollViewProxy in
                    ScrollView(.vertical) {
                        VStack(spacing: 2) {
                            ForEach(groupedUsers[index]) { user in
                                RoundedRectangle(cornerRadius: 2)
                                    
                                    .fill(Color.white.opacity(0.96))
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
                    .onAppear {
                        scrollViewProxy.scrollTo(offsets[index], anchor: .top)
                    }
                }
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

struct ConnectedUserInfo: View {
    
    var sampleCities: [String] = ["nyc", "chicago", "miami", "boston", "london"]
    var user: ConnectedUser
    
    var body: some View {
        let initials = "\(user.firstName?.first.map { String($0) } ?? "")\(user.surname?.first.map { String($0) } ?? "")"
        
        
        ZStack {
            VStack {
                HStack(alignment: .top, spacing: 12) {
                  
                    
                        
                    
                    VStack(alignment: .leading, spacing: 4) {
                        if let city = user.city {
                            let cityIndex = city - 1
                            let cityName = sampleCities[cityIndex]
                            Text(cityName)
                                .fontWeight(.bold)
                        }
                        if let industry = user.industry {
                            Text(industry)
                                .font(.system(size: 12))
                        }
                        
                        if let ageRange = user.ageRange {
                            Text(ageRange)
                                .font(.system(size: 10))
                                .padding(.bottom, 44)
                        }
                        
                        Rectangle()
                            .frame(width: 100, height: 1)
                            .padding(.bottom, 18)
                            
                        if let hobbies = user.hobbies {
                            HStack(spacing: 2) {
                                ForEach(hobbies, id: \.self) { hobby in
                                    Image(systemName: hobbyToSystemName(hobby: hobby))
                                        .font(.system(size: 12))
                                        .padding(.bottom, 6)
                                }
                            }
//                            .background(Color.gray.opacity(0.2))
                            .offset(x: 20)
                          
                          
                            
                        }
                           
                    }
                    
                    .padding(.bottom, 48)
                    .font(.system(size: 12))
                    .textCase(.uppercase)
                }
              
            
            }
            .padding(.horizontal, 6)
        .padding(.vertical, 44)
        }
        Text(initials)
            .font(.system(size: 44))
            .rotationEffect(Angle(degrees: -90))
            .foregroundStyle(Color.black.opacity(0.01))
            .customStroke(color: .white, width: 2)
            
            .offset(x: 0, y: 0)
    }
    
    func hobbyToSystemName(hobby: String) -> String {
        switch hobby.lowercased() {
        case "reading":
            return "books.vertical.circle.fill"
        case "music":
            return "music.note"
        case "sports":
            return "sportscourt"
        case "cooking":
            return "fork.knife"
        case "travel":
            return "airplane"
        case "hiking":
            return "figure.hiking"
        case "climbing":
            return "figure.climbing"
        case "crypto":
            return "bitcoinsign.circle.fill"
        case "clubbing":
            return "music.mic"
        case "racket":
            return "sportscourt"
        case "art":
            return "paintbrush.pointed"
        case "gaming":
            return "gamecontroller"
        case "horticulture":
            return "leaf"
        case "painting":
            return "paintpalette"
        case "birding":
            return "binoculars"
        case "running":
            return "figure.run"
        case "drawing":
            return "pencil.tip"
        case "coding":
            return "desktopcomputer"
        case "games":
            return "gamecontroller"
        case "sewing":
            return "scissors"
        case "skiing":
            return "snowflake"
        case "wine tasting":
            return "wineglass"
        default:
            return "x.circle.fill"
        }
    }
}

#Preview(body: {
    ZStack {
        Color.black.opacity(0.8)
            .ignoresSafeArea()
        ConnectionViewer()
    }
   
})
