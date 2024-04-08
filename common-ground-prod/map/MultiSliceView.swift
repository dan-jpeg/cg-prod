//
//  MultiSliceView.swift
//  common-ground
//
//  Created by dan crowley on 2/20/24.
//

import SwiftUI

struct MultiSliceView: View {
    var namespace: Namespace.ID
    
    @Binding var isSelected: String
    
    var body: some View {
        HStack(spacing: -70) {
            VStack {
                MapSliceView(imageName: "mapPST", mapWidth: 105, isSelected: isSelected == "PST")
                    .matchedGeometryEffect(id: "mapPST", in: namespace)
                    .offset(x: 15, y: -10)
                    .onTapGesture {
                        withAnimation(.spring){
                            $isSelected.wrappedValue = "PST"
                        }
                    }
                    
                if isSelected == "PST" {
                    Text(isSelected)
                }
            }
            VStack {
                MapSliceView(imageName: "mapMST", mapWidth: 105, isSelected: isSelected == "MST")
                    .matchedGeometryEffect(id: "mapMST", in: namespace)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            $isSelected.wrappedValue = "MST"
                        }
                    }
                    
                if isSelected == "MST" {
                    Text(isSelected)
                }
            }
            VStack {
                MapSliceView(imageName: "mapCST", mapWidth: 105, isSelected: isSelected == "CST")
                    .matchedGeometryEffect(id: "mapCST", in: namespace)
                    .frame(minHeight: 300)
                    .offset(y: 10)
                    .onTapGesture {
                        withAnimation(.smooth(duration: 0.6)){
                            $isSelected.wrappedValue = "CST"
                        }
                    }
                    
                if isSelected == "CST" {
                    Text(isSelected)
                }
            }
            VStack {
                MapSliceView(imageName: "mapEST", mapWidth: 105, isSelected: isSelected == "EST")
                    .matchedGeometryEffect(id: "mapEST", in: namespace)
                    
                    .onTapGesture {
                        withAnimation(.default) {
                            $isSelected.wrappedValue = "EST"
                        }
                    }
                    
                if isSelected == "EST" {
                    Text(isSelected)
                }
            }
           
        }
        .frame(minHeight: 250 )
        .offset(x: -15)
    }
}


