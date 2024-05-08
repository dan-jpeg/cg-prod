    //
    //  CityView.swift
    //  common-ground-prod
    //
    //  Created by dan crowley on 4/22/24.
    //

import SwiftUI
import SwiftfulUI

struct CityConnectionView: View {
    let cityName: String
    let countryCode: String
    let fraction: (numerator: Int, denominator: Int) // A tuple representing the fraction

    var ratio: CGFloat { // Computed property to get the ratio
        CGFloat(fraction.numerator) / CGFloat(fraction.denominator)
    }

    @Binding var showNumbers: Bool

    var body: some View {
        
                
                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                    VStack {
                        Circle()
                            .frame(width: 10, height: 10)
                            .position(x: geometry.size.width-6.5 , y: geometry.size.height * (1 - ratio))

                        if showNumbers {
                            // Display the fraction instead of ratio.description
                            Text("\(fraction.numerator)/\(fraction.denominator)")
                                .font(.system(size: 11, weight: .medium, design: .monospaced))
                                .position(x: geometry.size.width / 2 + 10, y: geometry.size.height * (1 - ratio) - 150)
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
                    
                }
                
                
                }
                    .overlay(alignment: .trailing) {
                    Rectangle()
                        .fill(.gray.opacity(0.52))
                        .frame(width: 1)
                       
                        
                }
               

               
        }
                .frame(minWidth: 80, maxWidth: 2)
                
        .padding(.horizontal)
    }
}

struct ParentView: View {
    @State var showNumbers: Bool = false
    let cities: [(name: String, code: String, fraction: (Int, Int))] = [
        ("New York", "US", (9, 12)),
        ("Chicago", "US", (5, 15)),
        ("London", "UK", (2, 12)),
        ("Paris", "FR", (5, 30)),
        ("Miami", "US", (18, 22)),
        ("New York City", "US", (12, 24)),
        ("Chicago", "US", (7, 10)),
        ("London", "UK", (1, 5)),
        ("Paris", "FR", (22, 25)),
        ("Miami", "US", (11, 25))
    ]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .center, spacing: 8) {
                ForEach(cities, id: \.name) { city in
                    CityConnectionView(cityName: city.name, countryCode: city.code, fraction: city.fraction, showNumbers: Binding.constant(true))
                        
                        
                }
            }
        }
        .scrollIndicators(.hidden)
        .frame(height: 340)
        .padding(.horizontal, 20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ParentView()
    }
}
