import SwiftUI
import SwiftfulUI


struct CityConnectionView: View {
    let cityName: String
    let countryCode: String
    let fraction: (numerator: Int, denominator: Int)
    var rotated: Bool = false
    
    var ratio: CGFloat {
        CGFloat(fraction.numerator) / CGFloat(fraction.denominator)
    }

    var showNumbers: Bool = true

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    VStack {
                        Circle()
                            .frame(width: 10, height: 10)
                            .position(x: geometry.size.width - 6.5, y: geometry.size.height * (1 - ratio))
                            .opacity(rotated ? 0 : 0.8)

                        if showNumbers {
                            Text("\(fraction.numerator)/\(fraction.denominator)")
                                .font(.system(size: 11, weight: .medium, design: .monospaced))
                                .position(x: geometry.size.width / 2 + 10, y: geometry.size.height * (1 - ratio) - 150)
                                .rotationEffect(Angle(degrees: rotated ? -90 : 0))
                                .offset(x: rotated ? 100 : 0)
                        }
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        Text(cityName)
                            .font(.system(size: 11, weight: .medium, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            
                        Text(countryCode)
                            .font(.system(size: 9, weight: .light, design: .monospaced))
                            .padding(.top, 1)
                            .padding(.trailing, 3)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            
                    }
                    .opacity(rotated ? 0 : 0.8)
                }
                
            }
            .overlay(alignment: rotated ? .leading : .trailing) {
                Rectangle()
                    .fill(Color.gray.opacity(0.52))
                    .frame(width: 2)
                    .offset(y: rotated ? 100 : 0)
                    
                    
            }
        }
        .frame(minWidth: 80, maxWidth: 200)
        .padding(.horizontal)
    }
}

struct CitySectionScrollable: View {
    
    var rotated: Bool = false
    @Binding var scrollPosition: Int? 
    
    var cities: [City] = []

  

    @State private var originState: String = ""

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                ForEach(cities) { city in
                    ZStack {
                        CityConnectionView(cityName: city.name, countryCode: "US", fraction: (city.revealedConnections, city.totalConnections), rotated: rotated)
                            .padding()
                            
                        if let pos = scrollPosition {
                            Text(pos.description)
                                .opacity(0)
                            Text(cities[pos].name)
                                .opacity(rotated ? 0.8 : 0)
                                .rotationEffect(.degrees(270))
                                .offset(x: -100, y: 0)
                        }
                            
                    }
                    .id(city.id)
                    .containerRelativeFrame(.horizontal)
                }
            }
        }
        
        .scrollIndicators(.hidden)
        .frame(height: 340)
        .padding(.horizontal, 20)
        .scrollPosition(id: $scrollPosition)
        .scrollTargetLayout()
        .ignoresSafeArea(.all)
        .scrollTargetBehavior(.paging)
    }
}

struct CityView_Previews: PreviewProvider {
    @Namespace static var namespace  // Declare a static namespace for the preview

    static var previews: some View {
        MapDetailView(namespace: namespace, imageName: "mapEST", menuState: .constant(.mapDetail))
            .previewLayout(.sizeThatFits)
            
    }
}


