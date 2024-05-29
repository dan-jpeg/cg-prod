//
//  WhiteOnBlackView.swift
//  common-ground-prod
//
//  Created by dan crowley on 5/24/24.
//

import SwiftUI

struct WhiteOnBlackView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.88)
                .ignoresSafeArea(.all)
            ScrollView {
                
            }.frame(width: UIScreen.main.bounds.width - 80, height: UIScreen.main.bounds.height - 0)
                .background(Color.white)
        }
    }
}

#Preview {
    WhiteOnBlackView()
}
