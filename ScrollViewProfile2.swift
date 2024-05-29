//
//  ScrollViewProfile.swift
//  common-ground-prod
//
//  Created by dan crowley on 5/20/24.
//

import SwiftUI
import SwiftfulUI

struct ScrollViewProfile2: View {
    
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
                    ZStack(alignment: .center) {
                        HStack {
                            nameSection(user: .mock, namespace: namespace)
                                .frame(maxWidth: .infinity)
                                .allowsHitTesting(false)
                                .opacity(viewState != .hometown ? 0.8 : 0.0)
                            
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
                                
                                .rotationEffect(.degrees(viewState == .hometown ? -90 : 0))
                                .opacity(viewState == .hometown ? 0.8 : 0.0)
                                .font(.system(size: 11))
                                .offset(x: 25, y: -95)
                                .scaleEffect(viewState == .hometown ? 1.3 : 1.0) // Adjust scale as needed
                                .offset(viewState == .hometown ? CGSize(width: -150, height: 50) : .zero) // Adjust offset as needed
                                
                                
                            }
                            .matchedGeometryEffect(id: "citycorner", in: namespace)
                            .frame(width: 120)
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
                        .frame(width: 340, height: 200)
                        
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
                        .opacity(viewState == .notEditing ? 0.8 : 0.0)
                        
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
                if origin.x < 200 && origin.x > 100 {
                    withAnimation {
                        viewState = .phoneNumber
                    }
                }
                if origin.x > 200 {
                    withAnimation {
                        viewState = .notEditing
                    }
                }
                if origin.x < 100 {
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
            .opacity(viewState != .notEditing ? 0.0 : 0.8)
            
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
        .scaleEffect(viewState == .phoneNumber ? 1.2 : 1.0) // Adjust scale as needed
        .offset(viewState == .phoneNumber ? CGSize(width: 60, height: -10) : .zero) // Adjust offset as needed
        .animation(.smooth(duration: 0.33), value: viewState) // Adjust animation as needed
    }
}

#Preview {
    ScrollViewProfile2()
}
