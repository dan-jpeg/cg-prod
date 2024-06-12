//
//  InitialsView.swift
//  common-ground-prod
//
//  Created by dan crowley on 6/3/24.
//

import SwiftUI



struct ParentTestView: View {
    var body: some View {
        
        ScrollView {
            
        }
        
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.9)
                    .ignoresSafeArea()
                Rectangle()
                    .fill(Color.white.opacity(0.8))
                    .frame(width: geometry.size.width * 0.618, height: geometry.size.height * 0.618)
                    
                ExpandedConnectedUserInfo(user: ConnectedUser.mockData[0])
                    .foregroundColor(.black)
                Rectangle()
                    .frame(width: geometry.size.width * 0.61, height: 1.5)
                    .offset(y: geometry.size.width / 5)
                    

                    
            }
           
                .overlay {
                    InitialsView()
                        .offset(y:  -geometry.size.width / 1.5)
                        
                    
                }
        }
        }
       
}
struct InitialsView: View {
    var initials: String = "z b"
    var size: CGFloat = 40
    var body: some View {
        VStack {
            StrokeText(text: initials, width: 2, color: .gray.opacity(0.8))
                .font(.system(size: size, weight: .black, design: .monospaced))
                .foregroundColor(.black)
                .textCase(.lowercase)
                
        }
        .opacity(0.8)
    }
}


struct ExpandedConnectedUserInfo: View {
    
    var sampleCities: [String] = ["nyc", "chicago", "miami", "boston", "london"]
    var user: ConnectedUser
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 12) {
                let initials = "\(user.firstName?.first.map { String($0) } ?? "")\(user.surname?.first.map { String($0) } ?? "")"
                
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
                    }
                }
                .padding(.bottom, 48)
                .font(.system(size: 12))
                .textCase(.uppercase)
            }
            
            if let hobbies = user.hobbies {
                HStack(spacing: 2) {
                    ForEach(hobbies, id: \.self) { hobby in
                        Image(systemName: hobbyToSystemName(hobby: hobby))
                            .font(.system(size: 12))
                            .padding(.bottom, 6)
                    }
                }
            }
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 44)
    }
    
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



