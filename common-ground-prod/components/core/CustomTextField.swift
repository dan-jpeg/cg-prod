//
//  CustomTextField.swift
//  common-ground-prod
//
//  Created by dan crowley on 3/20/24.
//

import SwiftUI

struct CustomTextField: View {
    let label: String
    let placeHolder: String
    @Binding var text: String
    let isSecure: Bool
    
    
    @State private var width = CGFloat.zero
    @State private var labelWidth = CGFloat.zero
   
    
    var body: some View {
           HStack {
               Group {
                   if isSecure {
                       SecureField(placeHolder, text: $text)
                           .foregroundColor(.black)
                           .font(.system(.subheadline, design: .monospaced, weight: .bold))
                           .padding(EdgeInsets(top: 15, leading: 60, bottom: 15, trailing: 60))
                   } else {
                       TextField(placeHolder, text: $text)
                           .foregroundColor(.black)
                           .font(.system(.subheadline, design: .monospaced, weight: .bold))
                           .padding(EdgeInsets(top: 15, leading: 60, bottom: 15, trailing: 60))
                   }
               }
                   .overlay {
                       GeometryReader { geo in
                           Color.clear.onAppear {
                               width = geo.size.width
                           }
                       }
                   }
           }
           .background {
               ZStack {
                   RoundedRectangle(cornerRadius: 5)
                       .trim(from: 0, to: 0.55)
                       .stroke(.gray, lineWidth: 1)
                   
                   RoundedRectangle(cornerRadius: 5)
                       
                       .stroke(.gray, lineWidth: 1)
                   
                   HStack {
                       Spacer()
                   BoxView(size: 2, offset: -10)
                           .offset(y: 12)
                   }
                   .frame(maxWidth: .infinity)
                   .padding(9)
                   CircleFillText(text: label, fill: false)
                       .overlay {
                           GeometryReader { geo in
                               Color.clear.onAppear {
                                   labelWidth = geo.size.width
                               }
                           }
                       }
                       .padding(2)
                       .font(.system(size: 20, weight: .light, design: .monospaced))
                       .textCase(.uppercase)
                       .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                       .offset(x: 0, y: -30 )
               }
           }.padding()
           }
   }



#Preview {
    CustomTextField(label: "EMAIL", placeHolder: "name", text: .constant(""), isSecure: false)
}



