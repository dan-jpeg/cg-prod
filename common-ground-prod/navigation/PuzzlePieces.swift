//
//  PuzzlePieces.swift
//  common-ground-prod
//
//  Created by dan crowley on 5/22/24.
//

import SwiftUI


struct Prototype: Identifiable {
    var id = UUID()
    var icon: String
    var title: String
    var view: AnyView
}


struct Prototype1: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Text("This is Prototype 1")
            .font(.largeTitle)
    }
}

struct Prototype2: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Text("This is Prototype 2")
            .font(.largeTitle)
            .onTapGesture {
                dismiss()
            }
    }
}

struct Prototype3: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Text("This is Prototype 3")
            .font(.largeTitle)
    }
}
struct PuzzlePieces: View {
    @State private var isAnimating: Bool = false
    @State private var tapCount: Int = 0
    @State private var secondAnimation: Bool = false
    @State private var selectedPrototype: Prototype? = nil
    var onBackPress : (() -> Void)? = nil
    
    private let prototypes = [
        Prototype(icon: "viewfinder", title: "Prototype 1", view: AnyView(ArrowPrototype())),
        Prototype(icon: "viewfinder", title: "Prototype 2", view: AnyView(AddressBookPrototype())),
        Prototype(icon: "viewfinder", title: "Prototype 3", view: AnyView(ScrollViewPrototype1())),
        Prototype(icon: "viewfinder", title: "Prototype 4", view: AnyView(ScrollViewPrototype2())),
        Prototype(icon: "viewfinder", title: "Prototype 5", view: AnyView(ProfilePrototype3())),
        Prototype(icon: "viewfinder", title: "Prototype 6", view: AnyView(ConnectionsPrototype()))
    ]
    
    var body: some View {
        
        VStack {
            HStack(spacing: 0) {
                Image(systemName: "puzzlepiece.extension")
                    .offset(x: isAnimating || secondAnimation ? 14 : -10 )
                Image(systemName: "puzzlepiece")
                    .rotationEffect(.degrees(isAnimating || secondAnimation ? -90 : 0 ))
                    .offset(x: isAnimating || secondAnimation ? 0 : 10 )
                Image(systemName: "puzzlepiece.extension")
                    .rotationEffect(.degrees(isAnimating || secondAnimation ? 90 : 0 ))
                    .rotationEffect(.degrees(secondAnimation ? 90 : 0 ))
                    .offset(x: isAnimating || secondAnimation ? -5 : 220 )
                    .offset(x: secondAnimation ? -9 : 0 )
            }
            .padding(.bottom, 72)
            .onTapGesture {
                withAnimation(.smooth) {
                    if tapCount == 0 {
                        isAnimating.toggle()
                        tapCount = 1
                    } else {
                        secondAnimation.toggle()
                        tapCount = 0
                        isAnimating = false
                    }
                }
            }
            
            if secondAnimation {
                VStack(spacing: 48) {
                    ForEach(prototypes) { prototype in
                        PrototypeListEntry(prototype: prototype, selectedPrototype: $selectedPrototype)
                    }
                    
                    Rectangle()
                        .frame(height: 2)
                        .frame(maxWidth: 48)
                        .padding(.top, 48)
                        .offset(x: 40)
                        .onTapGesture {
                            onBackPress?()
                        }
                }
                .padding(.horizontal, 48)
            }
        }
        .fullScreenCover(item: $selectedPrototype) { prototype in
            prototype.view
        }
    }
}

#Preview {
    PuzzlePieces()
}

struct PrototypeListEntry: View {
    var prototype: Prototype
    @Binding var selectedPrototype: Prototype?
    
    var body: some View {
        HStack(spacing: 24) {
            Image(systemName: prototype.icon)
            Text(prototype.title)
        }
        .font(.system(size: 10, weight: .light, design: .monospaced))
        .onTapGesture {
            selectedPrototype = prototype
        }
    }
}




