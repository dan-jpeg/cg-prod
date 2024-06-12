import SwiftUI

struct SomeView: View {
    var body: some View {
        
        
        StrokeText(text: "ZB", width: 2, color: .white)
            .foregroundColor(.black)
            .font(.system(size: 100, weight: .bold, design: .monospaced))

    }
}

struct StrokeText: View {
    let text: String
    let width: CGFloat
    let color: Color

    var body: some View {
        ZStack{
            ZStack{
                Text(text).offset(x:  width, y:  width)
                Text(text).offset(x: -width, y: -width)
                Text(text).offset(x: -width, y:  width)
                Text(text).offset(x:  width, y: -width)
            }
            .foregroundColor(color)
            Text(text)
        }
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.9)
            .ignoresSafeArea()
        HStack {
            SomeView()
            Text("ZB")
                .font(.system(size: 100, weight: .bold, design: .monospaced))
                .foregroundStyle(Color.white)
                .customStroke(color: .gray.opacity(0.7), width: 2)
        }

    }
    
}
