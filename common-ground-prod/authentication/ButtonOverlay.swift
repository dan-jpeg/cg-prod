//
//  ButtonOverlay.swift
//  common-ground-prod
//
//  Created by dan crowley on 3/15/24.
//

import SwiftUI

struct ButtonOverlay: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10) // Shape of the border
                .stroke(Color.black, lineWidth: 2)
                .ignoresSafeArea(.all)
                
    }
}

#Preview {
    ButtonOverlay()
}
