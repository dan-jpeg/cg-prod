//
//  HeartView.swift
//  common-ground-prod
//
//  Created by dan crowley on 3/24/24.
//

import SwiftUI

struct HeartView: View {
    
    var hasFill: Bool = true
    
    var body: some View {
        VStack(alignment: .center) {
            LogoViewNoNamespace(size: 10, rotationEffect: 50, rotationOverlay: -38, offset: [-2 ,2.5], offsetOverlay: [-1,0])
                .rotationEffect(Angle(degrees: -7))
                .padding(0)
//                    LogoViewNoNamespace(size: 40, rotationEffect: 20, rotationOverlay: 20, offset: [5 , 10])
//                       LogoViewNoNamespace(size: 40, rotationEffect: 0, rotationOverlay: 90, offset: [5 , 10])
//                        LogoViewNoNamespace(size: 40, rotationEffect: 90, rotationOverlay: 90, offset: [5 , 10])
//                        LogoViewNoNamespace(size: 40, rotationEffect: 90, rotationOverlay: 90, offset: [5 , 10])
//            Spacer()
        }
    }
}

#Preview {
    HeartView()
}

