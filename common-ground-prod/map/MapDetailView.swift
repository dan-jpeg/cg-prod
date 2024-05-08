import SwiftUI



import SwiftUI

struct MapDetailView: View {
    
    var namespace: Namespace.ID
    let borderColor2 = Color(UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 0.8))
    
    var imageName: String
    var sampleCities: [String] = ["New York City", "Miami", "Boston", "Washington DC", "Philadelphia"]
    var countryCodes: [String] = ["US", "US", "US", "US", "US"] // Example country codes
    var connectionRatios: [CGFloat] = [0.8, 0.6, 0.9, 0.7, 0.5] // Example ratios
    @Binding var menuState: MenuState
    @State private var selectedCityIndex: Int = 0

    @State private var showNumbers: Bool = false // Assume this state is needed for CityConnectionView

    var selectedCity: String {
        sampleCities[selectedCityIndex]
    }

    var selectedCountryCode: String {
        countryCodes[selectedCityIndex]
    }

    var selectedConnectionRatio: CGFloat {
        connectionRatios[selectedCityIndex]
    }

    var body: some View {
        VStack(spacing: 30) {
            HeaderView(namespace: namespace, squareSize: 60, menuState: $menuState)

            HStack {
                MapSliceView(imageName: imageName, mapWidth: 152, isSelected: false)
                    .matchedGeometryEffect(id: imageName , in: namespace)
                    
                    .frame(width: 250, alignment: .leading)
                Divider()
           
                    .frame(width: 100, height: 310) // Adjust width as necessary
                    

            }
            HStack {
                Button(action: {
                    selectedCityIndex = (selectedCityIndex - 1 + sampleCities.count) % sampleCities.count
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.gray)
                }
                Spacer()
                Text(selectedCity)
                    .textCase(.uppercase)
                Spacer()
                Button(action: {
                    selectedCityIndex = (selectedCityIndex + 1) % sampleCities.count
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color.gray)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .padding(.leading, 30)
            .padding(.trailing, 30)
        }
        .animation(.easeInOut, value: selectedCity)
    }
}


struct MapDetailView_Previews: PreviewProvider {
    @Namespace static var namespace  // Declare a static namespace for the preview

    static var previews: some View {
        MapDetailView(namespace: namespace, imageName: "mapEST", menuState: .constant(.mapDetail))
            .previewLayout(.sizeThatFits)
            
    }
}
