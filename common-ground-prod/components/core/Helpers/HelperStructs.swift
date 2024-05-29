//
//  SwiftUIView.swift
//  common-ground-prod
//
//  Created by dan crowley on 5/22/24.
//

import SwiftUI


struct SwipeToDismissView<Content: View>: View {
    @Environment(\.dismiss) var dismiss
    @State private var dragOffset = CGSize.zero
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .background(Color.clear) // Clear background
            .offset(x: dragOffset.width)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if gesture.translation.width > 0 {
                            dragOffset = gesture.translation
                        }
                    }
                    .onEnded { _ in
                        if dragOffset.width > 100 {
                            dismiss()
                        }
                        dragOffset = .zero
                    }
            )
            
    }
}



enum SwipeDirection {
    case left, right, up, down
}

struct SwipeWithActionView<Content: View>: View {
    @State private var dragOffset = CGSize.zero
    let content: Content
    let action: () -> Void
    let direction: SwipeDirection
    let distance: CGFloat

    init(
        direction: SwipeDirection = .right,
        distance: CGFloat = 100,
        @ViewBuilder content: () -> Content,
        action: @escaping () -> Void
    ) {
        self.direction = direction
        self.distance = distance
        self.content = content()
        self.action = action
    }

    var body: some View {
        content
            .background(Color.clear) // Clear background
            .offset(offsetForDirection())
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if isValidDrag(gesture) {
                            dragOffset = gesture.translation
                        }
                    }
                    .onEnded { _ in
                        if isSwipeSuccessful() {
                            action()
                        }
                        dragOffset = .zero
                    }
            )
            
    }

    private func offsetForDirection() -> CGSize {
        switch direction {
        case .left, .right:
            return CGSize(width: dragOffset.width, height: 0)
        case .up, .down:
            return CGSize(width: 0, height: dragOffset.height)
        }
    }

    private func isValidDrag(_ gesture: DragGesture.Value) -> Bool {
        switch direction {
        case .left:
            return gesture.translation.width < 0
        case .right:
            return gesture.translation.width > 0
        case .up:
            return gesture.translation.height < 0
        case .down:
            return gesture.translation.height > 0
        }
    }

    private func isSwipeSuccessful() -> Bool {
        switch direction {
        case .left:
            return dragOffset.width < -distance
        case .right:
            return dragOffset.width > distance
        case .up:
            return dragOffset.height < -distance
        case .down:
            return dragOffset.height > distance
        }
    }
}
