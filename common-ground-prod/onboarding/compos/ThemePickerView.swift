//
//  ThemePickerView.swift
//  common-ground-prod
//
//  Created by dan crowley on 4/18/24.
//

import SwiftUI
import UIKit

struct ThemePickerView: View {
    @State var isSelected: String = ""
    
    var body: some View {
        VStack(alignment: .center) {
            
           
           
                
                
                
            
          ZStack {

                
              HStack  {
                  HStack {
                  
                      if isSelected == "" {
                          Text("CHOOSE \n THEME:")
                      }
                         
                      
                      
                      
                  }
                  .frame(maxHeight: .infinity, alignment: .topLeading)
                  VStack(alignment: .center) {
                      ThemeImageView(themeName: "blue", isSelected: $isSelected)
                      ThemeImageView(themeName: "green", isSelected: $isSelected)
                      ThemeImageView(themeName: "red", isSelected: $isSelected)
                      if isSelected != "" {
                          
                          HStack {
                              Text("CHOSEN THEME:")
                                  .frame(alignment: .trailing)
                              Text(isSelected)
                                  .frame(alignment: .trailing)
                          }
                          .font(.system(size: 15))
                          .fontWeight(.bold)
                          .padding(.top, 32)
                          
                          .textCase(.uppercase)
                          
                         
                      }
                  }
                  
                  .animation(.smooth, value: isSelected)
              } .frame(alignment: .topLeading)
                
         
            
        } }
        .padding(16)
   
     
    }
    
   
    
}

struct ThemeImageView: View {
    var width: CGFloat = 120
    var themeName: String
    @Binding var isSelected: String
    
    var body: some View {
        VStack {
            Image("\(themeName)_theme_intro")
                .resizable()
                .scaledToFit()
                .frame(width: isSelected == themeName ?  width * 20.4 : width)
            
                .opacity(isSelected == themeName ?  0.96 : 0.55)
                
        }
        .onTapGesture {
            isSelected = themeName
        }
        
    }
}

struct ThemePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ThemePickerView()
    }
}
