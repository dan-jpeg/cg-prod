//
//  MapSliceView.swift
//  common-ground
//
//  Created by dan crowley on 2/20/24.
//

import SwiftUI

struct MapSliceView: View {
    let imageName: String
    let mapWidth: Double
    var isSelected: Bool
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: mapWidth)
            .padding()
//            .overlay(
//                Group {
//                    if isSelected {
//                        Image(imageName)
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: mapWidth)
//                          
//                            .foregroundStyle(Color.black)
//                    }
//                }
//            )
    }
}

#Preview {
    MapSliceView(imageName: "mapEST", mapWidth: 50, isSelected: true)
}
