import SwiftUI

struct StrokeModifier: ViewModifier {
    private let id = UUID()
    var strokeSize: CGFloat = 1
    var strokeColor: Color = .blue
    
    func body(content: Content) -> some View {
        content
            .padding(strokeSize*2)
            .background(
                Rectangle()
                    .foregroundStyle(strokeColor)
                    .mask({
                        outline(context: content)
                    })
            )
    }
    
    func outline(context: Content) -> some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.01))
            context.drawLayer { layer in
                if let text = context.resolveSymbol(id: id) {
                    layer.draw(text, at:  .init(x: size.width/2, y: size.height/2))
                }
            }
        } symbols: {
            context.tag(id)
                .blur(radius: strokeSize)
        }
    }
}

extension View {
    func customStroke(color: Color, width: CGFloat) -> some View {
        modifier(StrokeModifier(strokeSize: width, strokeColor: color))
    }
}

struct StrokeTestView: View {
    @State private var sampleText: String = "DC"
    
    var body: some View {
        Text(sampleText)
            .customStroke(color: .black, width: 1.27)
            .font(.system(size: 50))
            .foregroundStyle(Color.white)
            .kerning(4)
    }
}

#Preview {
    ZStack {
        Color.white.opacity(0.05)
            .ignoresSafeArea()
        StrokeTestView()
    }
    
}
