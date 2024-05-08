//
//  MessageBubbleView.swift
//  common-ground-prod
//
//  Created by dan crowley on 3/24/24.

//
import SwiftUI

struct MessageBubbleView: View {
    var message: String = "yooooo"
    var isScrolling: Bool
    @State var favorite: Bool
    @State private var heartOffset: CGFloat = -50
    
    
    
    var received: Bool = false
    @State private var heartScale: CGFloat = 1
    
    var onDoubleTap: (()->Void)? = nil
    
    var body: some View {
        HStack {        
            VStack(alignment: .trailing, spacing: 2){
            Text(message)
                .font(.system(size: 12, weight: isScrolling ? .bold :.light, design: .monospaced))
            
            HStack {
                
                if favorite {
                    
                    HeartView()
                        
                } else {
                    //                HeartView
                }
            }
        }.padding()
            .background(
                RoundedRectangle(cornerRadius: 14.0) // This creates a rounded rectangle background.
                    .stroke(Color.black.opacity(isScrolling ? 1.0 : 0.8), lineWidth: isScrolling ? 1.0 : 0.9)
                    .fill(Color.clear.opacity(0.2)) // Adjust color and opacity as needed.
                
            )
         
            .frame(maxWidth: .infinity, alignment: received ? .leading : .trailing)
        .animation(.smooth, value: isScrolling)
        }
        .onTapGesture(count: 2, perform: {
            if received {
                favorite.toggle()
                onDoubleTap?()
            }
          
        })
//        .onChange(of: favorite) {
//            handleOffsetChange()
//        }
        .animation(.smooth(duration: 0.91, extraBounce: 0), value: favorite)
//        .animation(.easeIn, value: heartOffset)
    }
//    private func handleOffsetChange() {
//        heartOffset = favorite ? 5 : -40
//    }
}



struct MessageBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MessageBubbleView(isScrolling: true, favorite: true, received: true)
            MessageBubbleView(isScrolling: true, favorite: true)
            
        }
    }
}
