import SwiftUI
import SwiftfulUI

struct CityProgressView: View {
    
    var city: City
    @State private var isAnimating: Bool = false
    
    var body: some View {
        ZStack(alignment: .center) {
            GeometryReader { geometry in
                let progress = CGFloat(city.revealedConnections) / CGFloat(city.totalConnections)
                
                // Background progress bar filling from bottom to top
//                Rectangle()
//                    
//                    .frame(width: geometry.size.width, height: geometry.size.height * progress)
//                    .animation(.linear, value: progress)
//                    .offset(y: geometry.size.height/4)
            }
            
            VStack(alignment: .center, spacing: 24) {
                Text(city.name)
                HStack {
                    Image(systemName: "\(city.revealedConnections).circle.fill")
                    Rectangle()
                        .fill(.gray.opacity(0.72))
                        .frame(width: 40, height: 2)
                        .rotationEffect(.degrees(isAnimating ? 125 : 0))
                    Image(systemName: "\(city.totalConnections).circle.fill")
                }
                .font(.system(size: 32))
                .fontWeight(.semibold)
            }
            .font(.system(size: 24))
            .fontWeight(.bold)
            .padding()
            .onAppear {
                withAnimation(.smooth(duration: 1.22, extraBounce: 0.6)) {
                    isAnimating = true
                }
            }
        }
        
        
    }
}

struct City: Identifiable, Equatable {
    let id: Int
    let name: String
    let totalConnections: Int
    let revealedConnections: Int
}

struct ScrollViewCities: View {
    
    let cities = [
        City(id: 1, name: "NEW YORK CITY", totalConnections: 10, revealedConnections: 6),
        City(id: 2, name: "LOS ANGELES", totalConnections: 12, revealedConnections: 8),
        City(id: 3, name: "CHICAGO", totalConnections: 8, revealedConnections: 5),
        City(id: 4, name: "HOUSTON", totalConnections: 15, revealedConnections: 10),
        City(id: 5, name: "PHOENIX", totalConnections: 7, revealedConnections: 4)
    ]

    @State private var originState: String = ""
    
    var body: some View {
        ScrollViewWithOnScrollChanged(.vertical, showsIndicators: false) {
            ForEach(cities) { city in
                ZStack {
                    CityProgressView(city: city)
                        .padding()
                }
                .containerRelativeFrame(.vertical)
            }
        } onScrollChanged: { origin in
            originState = origin.debugDescription
        }
        .scrollTargetLayout()
        .ignoresSafeArea(.all)
        .scrollTargetBehavior(.paging)
    }
}

#Preview {
    ScrollViewCities()
}
