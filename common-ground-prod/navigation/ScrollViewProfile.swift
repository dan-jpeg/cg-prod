//
//  ScrollViewProfile.swift
//  common-ground-prod
//
//  Created by dan crowley on 5/20/24.
//

import SwiftUI
import SwiftfulUI


struct ScrollViewPrototype1: View {
    var body: some View {
        SwipeToDismissView {
            ScrollViewProfile()
        }
    }
}

struct ScrollViewPrototype2: View {
    var body: some View {
        SwipeToDismissView {
            ScrollViewProfile2()
        }
    }
}
struct ScrollViewProfile: View {
    
    @State private var scrollOffset: CGFloat = .zero
    
    @Namespace private var namespace
    
    @State private var viewState: editSection = .notEditing
    
    @State private var phoneNumber: String = "PHONE"
    @State private var altPhoneNumber: String = "ALTPHONE"
    
    @State private var hometown: String = "chicago"
    
    var user: DBUser = .mock
    
    // Function to calculate rotation based on scroll offset
    func getRotation(scrollOffset: CGFloat, threshold: CGFloat, initialRotation: CGFloat) -> Angle {
        if scrollOffset > threshold {
            return Angle(degrees: initialRotation)
        } else {
            // Customize your formula as needed
            return Angle(degrees: scrollOffset * 2)
        }
    }

    // Function to calculate offset based on scroll offset
    func getOffset(scrollOffset: CGFloat, threshold: CGFloat, initialOffset: CGFloat) -> CGFloat {
        if scrollOffset > threshold {
            return initialOffset
        } else {
            // Customize your formula as needed
            return 0 - scrollOffset / 4
        }
    }
    
    
    var body: some View {
        ZStack {
            ObservableScrollView(scrollOffset: $scrollOffset) { proxy in
                VStack {
                    if viewState == .notEditing {
                        ZStack(alignment: .center) {
                            HStack {
                                nameSection(user: .mock, namespace: namespace)
                                    .frame(maxWidth: .infinity)
                                    .allowsHitTesting(false)
                               
                                
                                VStack(alignment: .trailing) {
                                    ZStack {
                                        HStack {
                                            Text("nyc")
                                            Image(systemName: "arrow.turn.up.left")
                                                .padding(.leading, 5)
                                                .overlay {
                                                    BoxView(size: 10, offset: getOffset(scrollOffset: scrollOffset, threshold: 666, initialOffset: 2.2))
                                                                        .rotationEffect(getRotation(scrollOffset: scrollOffset, threshold: 50, initialRotation: 0))
                                                        .offset(x: -18, y: 20)
                                                }
                                        }
                                        Text(hometown)
                                            .rotationEffect(.degrees(90))
                                            .offset(x: 20, y: 40)
                                      
                                    }
                                    .font(.system(size: 11))
                                    .offset(x: 25, y: -95)
                                    
                                }
                                .matchedGeometryEffect(id: "citycorner", in: namespace)
                                .frame(width: 100)
                                
                            }
                            .gesture(DragGesture(minimumDistance: 50, coordinateSpace: .local)
                                .onEnded({  value in
                                    if value.translation.width > 0 {
                                        withAnimation {
                                            viewState = .phoneNumber
                                        }
                                    }
                                }))
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
                        
                        .onTapGesture {
                            withAnimation {
                                viewState = .phoneNumber
                            }
                        }
                        
                        .padding(.horizontal, 12)
                        .padding(.vertical, 30)
                        
                        .background(Color.gray.opacity(0.1))
                    }
                    if viewState == .phoneNumber {
                        VStack {
                            phoneEditView(namespace: namespace, primaryPhoneNumber: $phoneNumber, secondaryPhoneNumber: $altPhoneNumber)
                                
                                .padding(.bottom, 120)
                            phoneNumberEditSection(primaryPhoneNumber: $phoneNumber, secondaryPhoneNumber: $altPhoneNumber)
                                .frame(width: UIScreen.main.bounds.width / 1.62)
                        }
                        
                        .padding(.top, 48)
                        .gesture(DragGesture(minimumDistance: 50, coordinateSpace: .local)
                            .onEnded({  value in
                                if value.translation.width < 0 {
                                    withAnimation {
                                        viewState = .notEditing
                                    }
                                }
                            }))
                      
                    }
                    
                    if viewState == .hometown {
                        VStack(spacing: 120) {
                            editCityCornerView(namespace: namespace, hometown: $hometown)
                                .padding(.top, 48)
                                .offset(x: 100, y: -10)
                            hometownEditSection(hometown: $hometown)
                                .frame(width: UIScreen.main.bounds.width / 1.62)
                        }
                       
                    }
                }
            }
            ScrollViewWithOnScrollChanged(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    Group {
                        
                        HoriArrows(singleArrows: true)
                            .rotationEffect(.degrees(180))
                        HoriArrows()
                        
                        HoriArrows()
                    }
                    .scaleEffect(0.5)
        
                }
                
            } onScrollChanged: { origin in
                if origin.x < 200 && origin.x > 100{
                    withAnimation {
                        viewState = .phoneNumber
                    }
                }
                if origin.x > 200 {
                    withAnimation {
                        viewState = .notEditing
                    }
                }
                if origin.x < 100  {
                    withAnimation {
                        viewState = .hometown
                    }
                }
                
            }
            .containerRelativeFrame(.horizontal)
            .scrollTargetLayout()
            .scrollTargetBehavior(.paging)
            .scrollBounceBehavior(.basedOnSize)

        }
    }
    
    private func nameSection(user: DBUser, namespace: Namespace.ID) -> some View {
        
        
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
                                    .matchedGeometryEffect(id: "phone1", in: namespace)
                            }
                        CircleFillText(text: "6305611337", fill: false)
                            .overlay {
                                Text("+1")
                                    .offset(x: -100)
                                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                                    .matchedGeometryEffect(id: "phone2", in: namespace)
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

#Preview {
    ScrollViewProfile()
}

struct editCityCornerView: View {
    
    var namespace: Namespace.ID
    
    @State private var scrollOffset: CGFloat = .zero
    @State private var rotation: Angle = .degrees(0)
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    
    @Binding var hometown: String
    
    func getRotation(scrollOffset: CGFloat, threshold: CGFloat, initialRotation: CGFloat) -> Angle {
        if scrollOffset > threshold {
            return Angle(degrees: initialRotation)
        } else {
            return Angle(degrees: scrollOffset * 2)
        }
    }

    func getOffset(scrollOffset: CGFloat, threshold: CGFloat, initialOffset: CGFloat) -> CGFloat {
        if scrollOffset > threshold {
            return initialOffset
        } else {
            return 0 - scrollOffset / 4
        }
    }
    
    var body: some View {
        VStack(alignment: .trailing) {
            ZStack {
                HStack {
                    Text("nyc")
                    Image(systemName: "arrow.turn.up.left")
                        .padding(.leading, 5)
                        .overlay {
                            BoxView(size: 10, offset: getOffset(scrollOffset: scrollOffset, threshold: 666, initialOffset: 2.2))
                                .rotationEffect(getRotation(scrollOffset: scrollOffset, threshold: 50, initialRotation: 0))
                                .offset(x: -18, y: 20)
                        }
                }
                Text(hometown)
                    .rotationEffect(.degrees(90))
                    .offset(x: 20, y: 40)
              
            }
            .font(.system(size: 11))
            .offset(x: 25, y: -95)
            
        }
        .frame(maxWidth: .infinity)
        .offset(y: 100)
        .matchedGeometryEffect(id: "citycorner", in: namespace)
        .rotationEffect(rotation)
        .scaleEffect(scale)
        .offset(offset)
        .onAppear {
            withAnimation(.smooth(duration: 0.3).delay(0.3)) {
                rotation = .degrees(-90)
                scale = 1.5
                offset = CGSize(width: -150, height: 60)
            }
        }
    }
}

struct HoriArrows: View {
    var singleArrows: Bool = false
    var body: some View {
        VStack {
            Image("downArrow")
                .resizable()
                .scaledToFit()
                .frame(width: 18)
                .rotationEffect(.degrees(90))
            if !singleArrows {
                Image("downArrow")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18)
                    .rotationEffect(.degrees(270))
            }
           
            
        }
        .frame(width: UIScreen.main.bounds.width)
    }
}
