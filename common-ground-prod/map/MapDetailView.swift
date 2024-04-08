import SwiftUI

struct MapDetailView: View {
    
    var namespace: Namespace.ID
    let borderColor2 = Color(UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 0.8))
    
    var imageName: String
     var sampleCities: [String] = ["New York City", "Miami", "Boston", "Washington DC", "Philadelphia"]
    @Binding var menuState: MenuState
    // Use a State to hold the index of the currently selected city
    @State private var selectedCityIndex: Int = 0
    
    // Computed property to get the selected city based on the index
    var selectedCity: String {
        sampleCities[selectedCityIndex]
    }
    
    var body: some View {
       
           
            
            VStack(spacing: 30) {
             HeaderView(namespace: namespace, squareSize: 60, menuState: $menuState)

                HStack {
                    MapSliceView(imageName: imageName, mapWidth: 152, isSelected: false)
                        .matchedGeometryEffect(id: imageName , in: namespace)
                    VStack {
                        Text(selectedCity)
                            .textCase(.uppercase)
                            
                        Text("XXX") // Placeholder for additional details
                        Text("XXX") // Placeholder for additional details
                    }
                    .frame(minWidth: 200)
                }
                HStack {
                    // Button to go to the previous city
                    Button(action: {
                        // Decrease the selectedCityIndex, wrapping around if necessary
                        selectedCityIndex = (selectedCityIndex - 1 + sampleCities.count) % sampleCities.count
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color.gray)
                    }
                    Spacer()
                    Text(selectedCity)
                        .textCase(.uppercase)
                    // Button to go to the next city
                    Spacer()
                    Button(action: {
                        // Increase the selectedCityIndex, wrapping around if necessary
                        selectedCityIndex = (selectedCityIndex + 1) % sampleCities.count
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color.gray)
                    }
                }
                .frame(minWidth: 300)
                .padding(.leading, 30)
                .padding(.trailing, 30)
            }
        }
        }


