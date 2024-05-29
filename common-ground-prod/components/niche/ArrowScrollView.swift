//
//  ArrowScrollView.swift
//  common-ground-prod
//
//  Created by dan crowley on 5/21/24.
//

import SwiftUI

struct ArrowScrollView: View {
    
    @State private var scrollOffset: CGFloat = .zero
    
    var body: some View {
        
        ZStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("FOUNDED")
                    Text("2024")
                }
                
                .rotationEffect(.degrees(270))
                Spacer()
                VStack {
                    Text("YOU ___ ____")
                    Text("ARE ____")
                    Text(" HERE")
                }
                
                .rotationEffect(.degrees(270))
            }
            .opacity(scrollOffset > 200 ? 0 : 0.8)
            .padding(.horizontal, 12)
            .font(.system(size: 10, weight: .bold))
            .animation(.smooth, value: scrollOffset)
            .frame(maxHeight: .infinity, alignment: .top)
                
            
        
            ObservableScrollView(scrollOffset: $scrollOffset) { proxy in
                
                    
                    VStack {
                        Image("downArrow")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width-80, height: UIScreen.main.bounds.height/1.8)
                            .padding(.vertical, 48)
                            .padding(.bottom, 174)
                            .opacity(0.8)
                        TestView2(scrollOffset: scrollOffset)
                            
                        
                    }
            }
            .ignoresSafeArea(.all)
        }
    }
}

struct ArrowPrototype: View {
    var body: some View {
        SwipeToDismissView {
            ArrowScrollView()
        }
    }
}

#Preview {
    ArrowScrollView()
}
