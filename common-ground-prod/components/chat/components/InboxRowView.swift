//
//  SwiftUIView.swift
//  common-ground-prod
//
//  Created by dan crowley on 3/22/24.
//

import SwiftUI

struct InboxRowView: View {
    var isUnread: Bool = true
    var name: String = "name"
    var text: String = "testing message for you my friend please read good look how many line it is."
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack {
                
                BoxView(size: 15)
                    .opacity(isUnread ? 1.0 : 0)
                }
                
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                   
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .padding(.bottom, 3)
                Text(text)
                    .font(.system(size: 12))
                    .fontDesign(.monospaced)
                    .foregroundStyle(Color.gray)
                    .lineLimit(2)
                    .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
                    
                    
                    
                
            }
            .font(.subheadline)
//            HStack {
//                Text("2h")
//                Image(systemName: "chevron.right")
//                    .font(.footnote)
//                
//            }
        }
    }
}

#Preview {
    InboxRowView()
}
