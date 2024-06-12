//
//  TestView.swift
//  common-ground-prod
//
//  Created by dan crowley on 3/20/24.
//
import SwiftUI

// Simple preference that observes a CGFloat.
struct ScrollViewOffsetPreferenceKey: PreferenceKey {
  static var defaultValue = CGFloat.zero

  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value += nextValue()
  }
}

// A ScrollView wrapper that tracks scroll offset changes.
struct ObservableScrollView<Content>: View where Content : View {
  @Namespace var scrollSpace

  @Binding var scrollOffset: CGFloat
  let content: (ScrollViewProxy) -> Content

  init(scrollOffset: Binding<CGFloat>,
       @ViewBuilder content: @escaping (ScrollViewProxy) -> Content) {
    _scrollOffset = scrollOffset
    self.content = content
  }
    

  var body: some View {
    ScrollView {
      ScrollViewReader { proxy in
        content(proxy)
          .background(GeometryReader { geo in
              let offset = -geo.frame(in: .named(scrollSpace)).minY
              Color.clear
                .preference(key: ScrollViewOffsetPreferenceKey.self,
                            value: offset)
          })
      }
    }
    .coordinateSpace(name: scrollSpace)
    .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
      scrollOffset = value
    }
  }
}

struct AddressBookPrototype: View {
    var body: some View {
        SwipeToDismissView {
            TestView()
        }
    }
}

struct TestView: View {
    
    @State private var userScrolledToBottom: Bool = false
    @State private var scrollOffset = CGFloat.zero
    
    // Function to calculate rotation based on scroll offset
    func getRotation(scrollOffset: CGFloat, threshold: CGFloat, initialRotation: CGFloat) -> Angle {
        if scrollOffset > threshold {
            return Angle(degrees: initialRotation)
        } else {
            // Customize your formula as needed
            return Angle(degrees: scrollOffset / 5)
        }
    }

    // Function to calculate offset based on scroll offset
    func getOffset(scrollOffset: CGFloat, threshold: CGFloat, initialOffset: CGFloat) -> CGFloat {
        if scrollOffset > threshold {
            return initialOffset
        } else {
            // Customize your formula as needed
            return 0 - scrollOffset / 40
        }
    }
    
        var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                BoxView(size: 20, offset: getOffset(scrollOffset: scrollOffset, threshold: 666, initialOffset: 2.2))
                                    .rotationEffect(getRotation(scrollOffset: scrollOffset, threshold: 500, initialRotation: 0))
            }
           
            Spacer()
            
            VStack(spacing: 0) {
                HStack {
                   
                    BoxView(size: 80, offset: getOffset(scrollOffset: scrollOffset, threshold: 666, initialOffset: 2.2))
                                        .rotationEffect(getRotation(scrollOffset: scrollOffset, threshold: 666, initialRotation: 0))

                        
                    
                }
                 
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 2)
                    .padding(.bottom, 0)
                    .opacity(scrollOffset > 600 ? 0 : 1.0)
                
                ObservableScrollView(scrollOffset: $scrollOffset) { proxy in
                  
                        
                        LazyVStack(spacing: 0) {
                            
                            
                            CardRow(field1: "NEW ", field2: "YORK CITY")
                            
                            CardRow(field1: "DAN", field2: "2525")
                            CardRow(field1: "ASTRO", field2: "9524")
                            CardRow(field1: "NEW ", field2: "YORK CITY")
                            CardRow(field1: "DAN", field2: "2525")
                            CardRow(field1: "ASTRO", field2: "9524")
                            CardRow(field1: "NEW ", field2: "YORK CITY")
                            CardRow(field1: "DAN", field2: "2525")
                            CardRow(field1: "ASTRO", field2: "9524")
                            CardRow(field1: "DAN", field2: "2525")
                            CardRow(field1: "ASTRO", field2: "9524")
                            CardRow(field1: "NEW ", field2: "YORK CITY")
                            CardRow(field1: "DAN", field2: "2525")
                            CardRow(field1: "ASTRO", field2: "9524")
                            CardRow(field1: "NEW ", field2: "YORK CITY")
                            CardRow(field1: "DAN", field2: "2525")
                            CardRow(field1: "ASTRO", field2: "9524")
                                .padding(.bottom, 120)
                            
                            CardRow(field1: " ", field2: "COMMON", place: "GROUND")
                            
                            
                                .padding(.bottom, 50)
                            Color.clear
                                .frame(width: 0, height: 0, alignment: .top)
                                .onAppear {
                                    userScrolledToBottom = true
                                }
                                .onDisappear {
                                    userScrolledToBottom = false
                                }
                            
                        
                
                            
                        }
                    }
                }
                .animation(.easeIn, value: userScrolledToBottom)
                
                
//                .scrollTargetLayout()
//                .scrollTargetBehavior(.paging)
                
            }
        
            .padding(.top, 50)
        }
     
    }


struct NewStruct: View {
    @State private var scrollOffset = CGFloat.zero
    
    var body: some View {
        VStack(spacing: 0) {
            
            Spacer()
            ObservableScrollView(scrollOffset: $scrollOffset) { proxy in
                LazyVStack {
                    Image("downArrow")
                        .frame(width: 30)
                    ForEach(0..<50) { index in
                        CardRow()
                    }
                    
                }
            }
            .frame(height: UIScreen.main.bounds.height / 3)
            
        }
    }
}

#Preview {
    TestView4()
}


struct CardRow: View {
    var field1: String = "NAME"
    var field2: String = "0004"
    var place: String?

    
    var body: some View {
        VStack(spacing: 5) {
            HStack{
                HStack(spacing: 0) {
                    Text(field1)
                        .frame(maxWidth: .infinity, alignment: .leading) // Ensures this text is aligned to the leading edge
                        .textCase(.uppercase)
                    Text(field2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
                
                if let place {
                    Text(place)
                        .frame(maxWidth: .infinity, alignment: .trailing) // Ensures this text is aligned to
                    
                } else {
                    Text("place")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .textCase(.uppercase)
                    
                    
                }
                
                
            }.padding(.horizontal, 20)
            //                .background(.blue)
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 2)
                .padding(.bottom, 0)
        }
        .frame(height: 40)
        .scrollTransition { content, phase in
            content
                .offset(x: phase.isIdentity ? 0 : 20)
        }
        
        
    }
    
}

//#Preview {
//    TestView()
//}

#Preview {
    TestView3()
}



struct TestView2: View {
    
    @State private var userScrolledToBottom: Bool = false
    var scrollOffset = CGFloat.zero
    
    // Function to calculate rotation based on scroll offset
    func getRotation(scrollOffset: CGFloat, threshold: CGFloat, initialRotation: CGFloat) -> Angle {
        if scrollOffset > threshold {
            return Angle(degrees: initialRotation)
        } else {
            // Customize your formula as needed
            return Angle(degrees: scrollOffset / 5)
        }
    }

    // Function to calculate offset based on scroll offset
    func getOffset(scrollOffset: CGFloat, threshold: CGFloat, initialOffset: CGFloat) -> CGFloat {
        if scrollOffset > threshold {
            return initialOffset
        } else {
            // Customize your formula as needed
            return 0 - scrollOffset / 40
        }
    }
    
        var body: some View {
        VStack(spacing: 0) {
            
           
            Spacer()
            
            VStack(spacing: 0) {
                 
//                Rectangle()
//                    .frame(maxWidth: .infinity, maxHeight: 2)
//                    .padding(.bottom, 0)
//                    .opacity(scrollOffset > 600 ? 0 : 1.0)
                
                ScrollView {
                  
                    
                        LazyVStack(spacing: 0) {
                            HStack(spacing: 2) {
                                
                                Text("COMMON")
                                Spacer()
                                Text("GROUND")
                            }
                            
                            
                            .opacity(scrollOffset > 500 ? 0 : 0.8)
                            .frame(maxWidth: .infinity, alignment: .center)
                            
                            .padding(.bottom, 50)
                            .padding(.horizontal, 28)
                            
                            CardRow(field1: "NEW ", field2: "YORK CITY")
                            
                            CardRow(field1: "DAN", field2: "2525")
                            CardRow(field1: "ASTRO", field2: "9524")
                            CardRow(field1: "NEW ", field2: "YORK CITY")
                            CardRow(field1: "DAN", field2: "2525")
                            CardRow(field1: "ASTRO", field2: "9524")
                            CardRow(field1: "NEW ", field2: "YORK CITY")
                            CardRow(field1: "DAN", field2: "2525")
                            CardRow(field1: "ASTRO", field2: "9524")
                            CardRow(field1: "DAN", field2: "2525")
                            CardRow(field1: "ASTRO", field2: "9524")
                            CardRow(field1: "NEW ", field2: "YORK CITY")
                            CardRow(field1: "DAN", field2: "2525")
                            CardRow(field1: "ASTRO", field2: "9524")
                            CardRow(field1: "NEW ", field2: "YORK CITY")
                            CardRow(field1: "DAN", field2: "2525")
                            CardRow(field1: "ASTRO", field2: "9524")
                                .padding(.bottom, 120)
                            
                            CardRow(field1: " ", field2: "COMMON", place: "GROUND")
                            
                            
                                .padding(.bottom, 50)
                            Color.clear
                                .frame(width: 0, height: 0, alignment: .top)
                                .onAppear {
                                    userScrolledToBottom = true
                                }
                                .onDisappear {
                                    userScrolledToBottom = false
                                }
                            
                        
                
                            
                        }
                    }
                }
                .animation(.easeIn, value: userScrolledToBottom)
                .animation(.easeIn, value: scrollOffset)
                
                
//                .scrollTargetLayout()
//                .scrollTargetBehavior(.paging)
                
            }
        
            .padding(.top, 50)
        }
     
    }

struct TestView3: View {
    
    @State private var userScrolledToBottom: Bool = false
    var scrollOffset = CGFloat.zero
    
    // Function to calculate rotation based on scroll offset
    func getRotation(scrollOffset: CGFloat, threshold: CGFloat, initialRotation: CGFloat) -> Angle {
        if scrollOffset > threshold {
            return Angle(degrees: initialRotation)
        } else {
            // Customize your formula as needed
            return Angle(degrees: scrollOffset / 5)
        }
    }

    // Function to calculate offset based on scroll offset
    func getOffset(scrollOffset: CGFloat, threshold: CGFloat, initialOffset: CGFloat) -> CGFloat {
        if scrollOffset > threshold {
            return initialOffset
        } else {
            // Customize your formula as needed
            return 0 - scrollOffset / 40
        }
    }
    
        var body: some View {
        VStack(spacing: 0) {
            
           
            Spacer()
            
            VStack(spacing: 0) {
                 
//                Rectangle()
//                    .frame(maxWidth: .infinity, maxHeight: 2)
//                    .padding(.bottom, 0)
//                    .opacity(scrollOffset > 600 ? 0 : 1.0)
                
                ScrollView {
                  
                    
                        LazyVStack(spacing: 0) {
                            HStack(spacing: 2) {
                                
                                Text("COMMON")
                                Spacer()
                                Text("GROUND")
                            }
                            
                            
                            .opacity(scrollOffset > 500 ? 0 : 0.8)
                            .frame(maxWidth: .infinity, alignment: .center)
                            
                            .padding(.bottom, 50)
                            .padding(.horizontal, 28)
                            
                            CardRow(field1: " ", field2: "_", place: "")
                            CardRow(field1: " ", field2: "_", place: "")
                            CardRow(field1: " ", field2: "_", place: "")
                            CardRow(field1: " ", field2: "_", place: "")
                            CardRow(field1: " ", field2: "_", place: "")
                            CardRow(field1: " ", field2: "_", place: "")
                            CardRow(field1: " ", field2: "_", place: "")
                            CardRow(field1: " ", field2: "_", place: "")
                            
                            
                            
                            
                            CardRow(field1: "____ ", field2: "_______")
                 
                                .padding(.bottom, 120)
                            
                            CardRow(field1: " ", field2: "COMMON", place: "GROUND")
                            
                            
                                .padding(.bottom, 50)
                            Color.clear
                                .frame(width: 0, height: 0, alignment: .top)
                                .onAppear {
                                    userScrolledToBottom = true
                                }
                                .onDisappear {
                                    userScrolledToBottom = false
                                }
                            
                        
                
                            
                        }
                    }
                }
                .animation(.easeIn, value: userScrolledToBottom)
                .animation(.easeIn, value: scrollOffset)
                
                
//                .scrollTargetLayout()
//                .scrollTargetBehavior(.paging)
                
            }
        
            .padding(.top, 50)
        }
     
    }


struct TestView4: View {
    
    @State private var userScrolledToBottom: Bool = false
    @State private var scrollOffset = CGFloat.zero
    
    // Function to calculate rotation based on scroll offset
    func getRotation(scrollOffset: CGFloat, threshold: CGFloat, initialRotation: CGFloat) -> Angle {
        if scrollOffset > threshold {
            return Angle(degrees: initialRotation)
        } else {
            // Customize your formula as needed
            return Angle(degrees: scrollOffset / 5)
        }
    }

    // Function to calculate offset based on scroll offset
    func getOffset(scrollOffset: CGFloat, threshold: CGFloat, initialOffset: CGFloat) -> CGFloat {
        if scrollOffset > threshold {
            return initialOffset
        } else {
            // Customize your formula as needed
            return 0 - scrollOffset / 40
        }
    }
    
        var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                BoxView(size: 20, offset: getOffset(scrollOffset: scrollOffset, threshold: 666, initialOffset: 2.2))
                                    .rotationEffect(getRotation(scrollOffset: scrollOffset, threshold: 500, initialRotation: 0))
            }
           
            Spacer()
            
            VStack(spacing: 0) {
                HStack {
                   
                    BoxView(size: 80, offset: getOffset(scrollOffset: scrollOffset, threshold: 666, initialOffset: 2.2))
                                        .rotationEffect(getRotation(scrollOffset: scrollOffset, threshold: 666, initialRotation: 0))

                        
                    
                }
                 
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 2)
                    .padding(.bottom, 0)
                    .opacity(scrollOffset > 600 ? 0 : 1.0)
                
                ObservableScrollView(scrollOffset: $scrollOffset) { proxy in
                  
                        
                        LazyVStack(spacing: 0) {
                            
                            
                            CardRow(field1: " ", field2: "_", place: "")
                            CardRow(field1: " ", field2: "_")
                            CardRow(field1: " ", field2: "_")
                            CardRow(field1: "", field2: "_")
                            CardRow(field1: " ", field2: "_", place: "")
                            CardRow(field1: " ", field2: "_", place: "")
                            CardRow(field1: " ", field2: "_", place: "")
                            CardRow(field1: " ", field2: "_", place: "chi")
                            CardRow(field1: " ", field2: "nyc", place: "")
                            CardRow(field1: " ", field2: " _", place: "")
                            CardRow(field1: "", field2: "___", place: "w")
                            CardRow(field1: " ", field2: "_", place: "nyc")
                            CardRow(field1: " ", field2: "", place: "w")
                            CardRow(field1: " ", field2: "____", place: "____")
                            CardRow(field1: " ", field2: "", place: "w")
                            CardRow(field1: " ", field2: "_", place: "w")
                            CardRow(field1: "PLACE ", field2: "", place: "PLACE")
                            CardRow(field1: " ", field2: "_", place: "nyc")
                            CardRow(field1: " ", field2: "_", place: "w")
                                .padding(.bottom, 120)
                            
                            CardRow(field1: " ", field2: "COMMON", place: "GROUND")
                            
                            
                                .padding(.bottom, 50)
                            Color.clear
                                .frame(width: 0, height: 0, alignment: .top)
                                .onAppear {
                                    userScrolledToBottom = true
                                }
                                .onDisappear {
                                    userScrolledToBottom = false
                                }
                            
                        
                
                            
                        }
                    }
                }
                .animation(.easeIn, value: userScrolledToBottom)
                
                
//                .scrollTargetLayout()
//                .scrollTargetBehavior(.paging)
                
            }
        
            .padding(.top, 50)
        }
     
    }


