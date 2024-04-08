//
//  ChatInputField.swift
//  common-ground-prod
//
//  Created by dan crowley on 4/5/24.
//

import SwiftUI
import SwiftfulUI

struct ChatInputField: View {
    
    let placeholder: String
    @Binding var newMessageBody: String
    
    var onEnterPressed: (()->Void)? = nil
    
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $newMessageBody)
                .foregroundColor(.black)
                .font(.system(.subheadline, design: .monospaced, weight: .bold))
                .padding(EdgeInsets(top: 15, leading: 60, bottom: 15, trailing: 60))
        }
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .trim(from: 0, to: 0.55)
                    .stroke(.gray, lineWidth: 1)
                
                RoundedRectangle(cornerRadius: 5)
                    
                    .stroke(.gray, lineWidth: 1)
                
                HStack {
                    Spacer()
                BoxView(size: 20, offset: -10)
                        .asButton {
                            Task {
                                onEnterPressed?()
                            }
                        }
                        .offset(y: 12)
                }
                .frame(maxWidth: .infinity)
                .padding(9)
                    
            }
        }
        
    }
    
}

#Preview {
    ZStack {
        ChatInputField(placeholder: "type message here", newMessageBody: .constant(""))
            .padding(.horizontal, 10)
        
    }
}
