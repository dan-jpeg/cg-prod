//
//  ChatViewHeader.swift
//  common-ground-prod
//
//  Created by dan crowley on 3/24/24.
//

import SwiftUI

struct ChatViewHeader: View {
    
    @Binding var menuState: MenuState
    var namespace: Namespace.ID
    @Binding var isChatViewPresented: Bool
    
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .trailing, spacing: 5) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("jinni")
                        Text("xu")
                    }
                    .font(.system(.caption, design: .monospaced, weight: .light))
                                  
                  
                  
                    HStack(alignment: .bottom) {
                        Text(" < ")
                            .onTapGesture {
                                withAnimation(.smooth) {
                                    isChatViewPresented = false
                                    
                                }
                            }
                        
                    }
                    
                }
                
                .fontWeight(.bold)
                .foregroundStyle(Color.black)
                .opacity(0.9)
                .padding(.leading, 32)
                Spacer()
                
                VStack(spacing: 24){
                    
                    LogoView(size: 30, namespace: namespace)
                    
                    
                    
                    VStack {
                        Text("CO")
                        Text("GR")
                    }
                    .matchedGeometryEffect(id: "logotext", in: namespace)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.black)
                    .opacity(0.9)
                    .font(.system(size: 19))
                    .offset(y: 5)
                    
                    .onTapGesture {
                        menuState = .welcome
                    }
                }
                .padding(.top, 20)
                .padding(30)
            }
            Divider()
        }
    }
}
