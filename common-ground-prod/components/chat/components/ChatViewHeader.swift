//
//  ChatViewHeader.swift
//  common-ground-prod
//
//  Created by dan crowley on 3/24/24.
//

import SwiftUI

struct ChatViewHeader: View {
    
    var name: String = "jinny xu"
    @Binding var menuState: MenuState
    var namespace: Namespace.ID
    @Binding var isChatViewPresented: Bool
    
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .trailing, spacing: 4) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(name)
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .font(.system(.caption, design: .monospaced, weight: .light))
                                  
                  
                  
                    HStack(alignment: .bottom) {
                        Image(systemName: "arrow.backward.square")
                            .font(.system(size: 30))
                            .fontWeight(.medium)
                            .onTapGesture {
                                withAnimation(.smooth) {
                                    isChatViewPresented = false
                                    
                                }
                            }
                        
                    } .frame(maxHeight: .infinity, alignment: .leading)
                    
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
        }.frame(height: 222)
    }
}
