//
//  DrawingRectangleView.swift
//  common-ground-prod
//
//  Created by dan crowley on 5/16/24.
//

import SwiftUI
import SwiftfulUI

@MainActor
final class ProViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = .mock
    
   
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userID: authDataResult.uid)
    }
}


enum editSection {
    
    case notEditing
    case name
    case phoneNumber
    case hometown
    case email
}

struct ProfilePrototype3: View {
    var body: some View {
        SwipeToDismissView {
            DrawingRectangleView()
        }
    }
}

struct ConnectionsPrototype: View {
    var body: some View {
        SwipeToDismissView {
            ConnectionViewer()
        }
    }
}

struct DrawingRectangleView: View {
    
    
    
    var user: DBUser = .mock
    @State private var progress: Double = 0 // animation progress
    @State private var duration: Double = 2 // animation duration
    
    @State private var isAnimating: Bool = false
    @State private var isEditing: Bool = false
    
    @StateObject private var viewModel = ProViewModel()
    
    @State private var editState: editSection = .notEditing
    
    let rectWidth: CGFloat = 360
    let rectHeight: CGFloat = 240

    
    var body: some View {
        

        ZStack {
        
            
            ScrollView {
                
                GeometryReader { geometry in
                    ZStack(alignment: .center) {
        
                        Path { path in
                            // Calculate centered coordinates
                            let rectX = (geometry.size.width - rectWidth) / 2
                            let rectY = (geometry.size.height - rectHeight) / 2
                            path.addRect(CGRect(x: rectX, y: rectY, width: rectWidth, height: rectHeight))
                        }
                        .offset(y: 95)
                        .trim(from: 0, to: progress)
                        .stroke(Color.black, style: StrokeStyle(lineWidth: 0.33, lineCap: .round, lineJoin: .round))
                        .onAppear {
                            withAnimation(.linear(duration: duration)) {
                                progress = 1
                            }
                        }
                        
                        HStack {
                            nameSection(user: .mock)
                                .frame(maxWidth: .infinity)
                                .allowsHitTesting(false)
                           
                            
                            VStack(alignment: .trailing) {
                                ZStack {
                                    HStack {
                                        Text("nyc")
                                        Image(systemName: "arrow.turn.up.left")
                                            .padding(.leading, 5)
                                            .overlay {
                                                BoxView(size: 10, offset: -10)
                                                    .offset(x: -18, y: 20)
                                            }
                                    }
                                    Text("chicago")
                                        .rotationEffect(.degrees(90))
                                        .offset(x: 20, y: 40)
                                  
                                }
                                .offset(x: 25, y: -95)
                                
                            }

                            .frame(width: 100)
                            
                        }
                        .padding(15)
                        .frame( width: 340, height: 200)
                        
                            
                        HStack {
                            if let email = user.email  {
                                Text(email)
                                
                                Text("userwebpageURLpossibly/real.com")
                                    .foregroundStyle(Color.black)
                                
                            }
                        }
                        .foregroundStyle(.primary)
                        .font(.system(size: 9))
                        
                        .offset(y: 95)
                        .frame(width: 330)
                        
                    }
                    .isFloating(true)
                    

                    
                    .scaleEffect(CGSize(width: 0.8, height: 0.8))
                    
                    .onTapGesture {
                        progress = 0
                        duration += 0.333
                        isEditing.toggle()
                        // Slight delay to ensure reset before animation
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.333) {
                            withAnimation(.linear(duration: duration)) {
                                progress = 1
                            }
                        }
                    }
                }
                .padding(.top, 150)
                .opacity(0.7)
                .font(.system(size: 11))
            }
            
            
            .ignoresSafeArea(.all)
            
        }
        HStack {
            Text("YOUR PROFILE")
        }
      
            .font(.system(size: 20))
            .fontDesign(.monospaced)
            .offset(y: -200)
        
        Button {
            editState = .name
        } label: {
            Text("EDIT")
                .font(.system(size: 16))
                .fontDesign(.monospaced)
                
                .opacity(0.2)
                
        }
        .offset(y: -144)
        Text("edit state \(editState.hashValue)")
      }
    
    private func nameSection(user: DBUser) -> some View {
        
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("common ground")
                Text("id: \(user.userId)")
            }
            .padding(.bottom, 72)
                
            VStack(alignment: .leading) {
                if let firstName = user.firstName, let lastName = user.surname {
                    HStack(spacing: 0) {
                       Text(firstName + " " + lastName)
                       Text("___ _ _")
                    }
                    .padding(.bottom, 12)
                    Group {
                        
                        CircleFillText(text: "6305611337", fill: true)
                            .overlay {
                                Text("+2")
                                    .offset(x: -100)
                                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                            }
                        CircleFillText(text: "6305611337", fill: false)
                            .overlay {
                                Text("+1")
                                    .offset(x: -100)
                                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                            }
                    }

                }
            }
            
            .font(.system(size: 15))
            .padding(.bottom, 32)
            .frame(maxWidth: .infinity)
            

        }
        .textCase(.uppercase)
        .font(.system(size: 11))
    }
  }


struct PreviewBanner: View {
    @State private var topAnimating: Bool = false
    @State private var bottomAnimating: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                CircleFillText(text: "PREVIEW", fill: true)
                CircleFillText(text: "PREVIEW")
                CircleFillText(text: "PREVIEW", fill: true)
                CircleFillText(text: "PREVIEW")
                CircleFillText(text: "PREVIEW", fill: true)
                CircleFillText(text: "PREVIEW")
                CircleFillText(text: "PREVIEW", fill: true)
                CircleFillText(text: "PREVIEW")
                CircleFillText(text: "PREVIEW", fill: true)
            }
            .offset(x: topAnimating ? -400 : 400)
            
            HStack {
                CircleFillText(text: "PREVIEW", fill: true)
                CircleFillText(text: "COMMON")
                CircleFillText(text: "GROUND", fill: true)
                CircleFillText(text: "PREVIEW")
                CircleFillText(text: "PREVIEW", fill: true)
                CircleFillText(text: "GROUND")
                CircleFillText(text: "PREVIEW", fill: true)
                CircleFillText(text: "COMMON")
                CircleFillText(text: "PREVIEW", fill: true)
            }
            .offset(x: topAnimating ? 200 : -400)
            HStack {
                CircleFillText(text: "COMMON", fill: true)
                CircleFillText(text: "GROUND")
                CircleFillText(text: "PREVIEW", fill: true)
                CircleFillText(text: "PREVIEW")
                CircleFillText(text: "PREVIEW", fill: true)
                CircleFillText(text: "PREVIEW")
                CircleFillText(text: "COMMON", fill: true)
                CircleFillText(text: "PREVIEW")
                CircleFillText(text: "GROUND", fill: true)
            }
            .offset(x: topAnimating ? 400 : -400)
        }
        .onAppear {
                withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                    topAnimating = true
                }
        }
    }
}
struct CircleFillText: View {
    
    
    var text: String = "card preview"
    var fill: Bool = false
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(text.lowercased().enumerated()), id: \.offset) { index, letter in
                if fill {
                    Image(systemName: "\(letter).circle.fill")
                        .accessibilityLabel("\(letter) circle")
                        .id("letter_\(index)_\(letter)_fill")
                } else {
                    Image(systemName: "\(letter).circle")
                        .accessibilityLabel("\(letter) circle")
                        .id("letter_\(index)_\(letter)_outline")
                }
            }
        }
    }
}


struct FloatingModifier: ViewModifier {
    @State private var isAnimating: Bool = false
    let enabled: Bool
    
    func body(content: Content) -> some View {
        content
            .offset(y: isAnimating ? 5 : -5)
            .onAppear {
                if enabled {
                    withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                        isAnimating = true
                    }
                }
            }
            .onChange(of: enabled) { newValue, _ in
                if !newValue {
                    withAnimation {
                        isAnimating = false
                    }
                } else {
                    withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                        isAnimating = true
                    }
                }
            }
    }
}

extension View {
    func isFloating(_ enabled: Bool) -> some View {
        self.modifier(FloatingModifier(enabled: enabled))
    }
}


#Preview {
    VStack {
        DrawingRectangleView()

        HStack {
            CircleFillText(text: "PREVIEW", fill: true)
            CircleFillText(text: "PREVIEW")
            CircleFillText(text: "PREVIEW", fill: true)
            CircleFillText(text: "PREVIEW")
            CircleFillText(text: "PREVIEW", fill: true)
        }
        HStack(spacing: 10) {
            CircleFillText(text: "PREVIEW", fill: false)
            CircleFillText(text: "12")
            CircleFillText(text: "345", fill: true)
            CircleFillText(text: "67890")
            CircleFillText(text: "PREVIEW", fill: true)
        }
        
        
        PreviewBanner()
            .padding(.vertical, 16)
       
    }
    
    
}




