//
//  SwiftUIView.swift
//  common-ground
//
//  Created by dan crowley on 3/4/24.
//

import SwiftUI


let logoColor1 = Color(UIColor(red: 75/255, green: 89/255, blue: 86/255, alpha: 0.8))
let borderColor = Color(UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 0.8))

struct CardSheet: View {
    @State private var isAnimating: Bool = false
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                CardRow(field1: "DAN", field2: "02523", place: "NEW YORK CITY")
                CardRow(field1: "AYANO", field2: "02524", place: "TOKYO")
                CardRow()
                Spacer()
            }
            .padding()
                
            
        }
    }
}
#Preview {
    CardSheet()
}
 
