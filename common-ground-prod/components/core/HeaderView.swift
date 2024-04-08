//
//  HeaderView.swift
//  common-ground
//
//  Created by dan crowley on 2/26/24.
//

import SwiftUI




struct HeaderView: View {
    let logoColor1 = Color(UIColor(red: 66/255, green: 89/255, blue: 86/255, alpha: 0.8))
    var namespace: Namespace.ID
    var squareSize: CGFloat
    
    @Binding var menuState: MenuState
    
    @State private var showCover: Bool = false
    

    var body: some View {
       
        HStack {
                LogoView(size: squareSize, namespace: namespace)
                .padding(.leading, 20)
                    .onTapGesture {
                        withAnimation {
                                    showCover = true
                        }
                    }
                    .sheet(isPresented: $showCover, content: {
                        RoloView()
                            .transition(.move(edge: .top))

                    })
                Spacer()
                Button(action: {
                    withAnimation(.smooth(duration: 1.2, extraBounce: 0.01)){
                        menuState = .welcome
                    }
                }, label: {
                 LogoTextView(namespace: namespace)
                })
            }
            .padding()
            .padding(.trailing, 50)
        
    }
}

