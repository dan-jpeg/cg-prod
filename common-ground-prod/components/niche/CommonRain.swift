//
//  CommonRain.swift
//  common-ground-prod
//
//  Created by dan crowley on 4/19/24.
//

import SwiftUI

struct CommonRain: View {
    
    @State var count: Int = 200
    
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
               
                ForEach(0..<count, id: \.self ) { _ in
                    HeartView()
                        .position(x: CGFloat.random(in: 100...geometry.size.width - 100),
                                  y: CGFloat.random(in: 150...geometry.size.height - 150))
                        .opacity(Double.random(in: 0.3...0.9))
                        
                }
                HStack(alignment: .bottom) {
                    
                    Button(action: {
                        count += 1
                    }, label: {
                        Text("+")
                    })
                    
                    Button(action: {
                        count -= 1
                    }, label: {
                        Text("-")
                    })
                }
                .font(.title)
                .foregroundStyle(Color.commonGreen)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .offset(y: 200)
             
                // spawn many here with random offsets
            }
            .frame(maxWidth: .infinity, maxHeight: 500)
            
        }
       
    }
}

struct RainText: View {
    var size: CGFloat = 22
    var body: some View {
        Text("COMMON")
            .font(.system(size: size))
            .foregroundStyle(Color.black)
            .rotationEffect(Angle(degrees: 90))
            
    }
}

#Preview {
    CommonRain()
}
