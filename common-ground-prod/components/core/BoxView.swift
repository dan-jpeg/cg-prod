

import SwiftUI

struct BoxView: View {
    var size: CGFloat
    var offset: CGFloat = 3
    var box1Opacity: CGFloat = 1.0
    var overlayOpacity: CGFloat = 1.0

    let logoColor1 = Color(UIColor(red: 66/255, green: 89/255, blue: 86/255, alpha: 0.8))
    
    var body: some View {
        
        VStack(alignment: .leading) {
            LogoShape(size: size)
    //            .matchedGeometryEffect(id: "rectangle", in: namespace)
                .frame(width: size * 2, height: size * 2)
                .foregroundColor(logoColor1)
                .aspectRatio(1, contentMode: .fit)
                
                .opacity(box1Opacity)
                .rotationEffect(.degrees(0))
                .offset(x: size * offset / 10, y: size * 9 / 50)
                .overlay(
                    LogoShape2(size: size)
    //                    .matchedGeometryEffect(id: "overlay", in: namespace)
                        .foregroundColor(logoColor1)
                        .aspectRatio(1, contentMode: .fit)
                        
                        .rotationEffect(.degrees(90))
                        .opacity(overlayOpacity)
                        
                    
                
                )
            .animation(.easeInOut, value: size)
            .animation(.easeIn, value: offset)
            Spacer()
        }
    }
}

#Preview {
    
    BoxView(size: 200, offset: 3)
}




