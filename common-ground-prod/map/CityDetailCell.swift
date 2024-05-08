//
//  CityDetailCell.swift
//  common-ground-prod
//
//  Created by dan crowley on 4/22/24.
//


import SwiftUI

struct CityDetailCellText: View {
    var name: String
    var connectionArray: [Int] // Ensure this array always contains at least two elements.
    var detail: String
    
    init(name: String = "New York City", connectionArray: [Int] = [5, 24], detail: String = "CONNECTED") {
        self.name = name
        self.connectionArray = connectionArray
        self.detail = detail
    }
    
    var body: some View {
        
        HStack {
            
        }
        VStack(alignment: .leading) {
            Text(name)
                .font(.system(size: 14, weight: .medium, design: .monospaced))
                .textCase(.uppercase)

            HStack {
                Text("\(connectionArray[0]) /")
                Text("\(connectionArray[1])")
            }
            .font(.system(size: 14, weight: .medium, design: .monospaced))
        }
        .padding()
    }
}

// Preview
struct CityDetailCellText_Previews: PreviewProvider {
    static var previews: some View {
        CityDetailCellText()
    }
}
