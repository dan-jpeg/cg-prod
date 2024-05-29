import SwiftUI



import SwiftUI

struct MapDetailView: View {
    
    var namespace: Namespace.ID
    let borderColor2 = Color(UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 0.8))
    
    var imageName: String
    @Binding var menuState: MenuState
    @State private var selectedCityIndex: Int = 0

    @State private var showNumbers: Bool = false // Assume this state is needed for CityConnectionView
    
    @State private var showCityConnectionDetail: Bool = false
    
    @State private var scrollPosition: Int? = 0
    @State private var selectedCity: City =  City(id: 1, name: "NEW YORK CITY", totalConnections: 10, revealedConnections: 6)
    
    @StateObject var rolodexState = RolodexViewModel()
    

    let cities = [
        City(id: 0, name: "NEW YORK CITY", totalConnections: 10, revealedConnections: 6),
        City(id: 1, name: "LOS ANGELES", totalConnections: 12, revealedConnections: 8),
        City(id: 2, name: "CHICAGO", totalConnections: 8, revealedConnections: 5),
        City(id: 3, name: "HOUSTON", totalConnections: 15, revealedConnections: 10),
        City(id: 4, name: "PHOENIX", totalConnections: 7, revealedConnections: 4)
    ]
    
    



    var body: some View {
        
        var scale1: CGSize = CGSize(width: 1.5, height: 1.5)
        var scale2: CGSize = CGSize(width: 1.5, height: 1.5)
        
        ZStack {
            VStack(spacing: 24) {
                HeaderView(namespace: namespace, squareSize: 60, menuState: $menuState)
                HStack(spacing: 0) {
                    MapSliceView(imageName: imageName, mapWidth: 152, isSelected: false)
                        .matchedGeometryEffect(id: imageName , in: namespace)
                    
                        .frame(width: 250, alignment: .leading)
                        .offset(x: showCityConnectionDetail ? -200 : 40 )
                        .scaleEffect(showCityConnectionDetail ? scale2 : scale1)
                    
                    CitySectionScrollable(rotated: showCityConnectionDetail, scrollPosition: $scrollPosition, cities: cities)
                        .frame(width: 200, height: 310) // Adjust width as necessary
                        .onTapGesture {
                            showCityConnectionDetail.toggle()
                        }
                    //                            .rotationEffect(Angle(degrees: showCityConnectionDetail ? 90 : 0 ))
                        .offset(x: -30, y: showCityConnectionDetail ? -400 : 0
                        )
                    
                }
                HStack {
                    Button(action: {
                        scrollPosition = 0
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color.gray)
                    }
                    Spacer()
                    Text(selectedCity.name)
                        .textCase(.uppercase)
                        .scaleEffect(showCityConnectionDetail ? 1.5 : 1 )
                    Spacer()
                    Button(action: {
                        if var pos = scrollPosition {
                            if pos <= 3 {
                                pos += 1
                                scrollPosition = pos
                            }
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color.gray)
                    }
                }
                .offset(y: showCityConnectionDetail ? -250 : 0 )
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .padding(.leading, 30)
                .padding(.trailing, 30)
                
                
                if showCityConnectionDetail {
                    ConnectionViewer()
                        
                        .onTapGesture {
                            showCityConnectionDetail.toggle()
                        }
                        .frame(maxWidth: .infinity)
                        .containerRelativeFrame(.vertical){ height, _ in height / 1.2}
                        .offset(y: -300)
                        
                }
            }
            
        }
        .onAppear {
            selectedCity = cities[0]
            
                Task {
                    do {
                        try await rolodexState.fetchConnectionStringsArray()
                        try await rolodexState.fetchConnections()
                        await rolodexState.getConnectedUserInfo()
                        print("finish fetch")
                    }
                    catch { }
                }
            
            
        }
        .onChange(of: scrollPosition, { oldValue, newValue in
            if let newPosition = newValue, newPosition >= 0 && newPosition < cities.count {
                selectedCity = cities[newPosition]
            }
        })
        
        .animation(.easeInOut, value: selectedCity)
        .animation(.smooth(duration: 1), value: showCityConnectionDetail)
        .animation(.smooth, value: scrollPosition)
    }
}


struct MapDetailView_Previews: PreviewProvider {
    @Namespace static var namespace  // Declare a static namespace for the preview

    static var previews: some View {
        MapDetailView(namespace: namespace, imageName: "mapEST", menuState: .constant(.mapDetail))
            
            
    }
}

//struct ConnectionSection: View {
//    var body: some View {
//        VStack {
//            HStack {
//                Text("CITY NAME")
//                Text("US")
//            }
//            
//            Text("pending")
//            ScrollView(.horizontal) {
//                LazyHStack {
//                    ForEach(1..<20) { _ in
//                        Rectangle()
//                            .fill(.green.opacity(0.1))
//                            .frame(width: 200, height: 50)
//                    }
//                }
//            }
//            Text("revealed")
//            ScrollView(.horizontal) {
//                LazyHStack {
//                    ForEach(1..<20) { _ in
//                        Rectangle()
//                            .fill(.green.opacity(0.1))
//                            .frame(width: 200, height: 120)
//                    }
//                }
//            }
//        }
//    }
//}
