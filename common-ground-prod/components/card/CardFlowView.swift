import SwiftUI

struct CardFlowView<Content: View, Item: RandomAccessCollection>: View where Item.Element: Identifiable {
    var itemWidth: CGFloat
    var spacing: CGFloat
    var items: Item
    var rotation: Double
    var content: (Item.Element) -> Content
    
    @State private var stack: [String] = []
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal) {
                ScrollViewReader { scrollViewProxy in
                    LazyHStack(spacing: 0) {
                        ForEach(items) { item in
                            content(item)
                                .frame(width: itemWidth)
                                .visualEffect { content, geometryProxy in
                                    content
                                        .rotation3DEffect(.init(degrees: rotation(geometryProxy)), axis: (x: 0, y: 1, z: 0), anchor: .center)
                                }
                                .padding(.trailing, item.id == items.last?.id ? 0 : spacing)
                        }
                    }
                    .padding(.horizontal, (geometry.size.width - itemWidth) / 2)
                    .onAppear {
                        // Scroll to the last item to start on the right side
                        if let lastItemId = items.last?.id {
                            scrollViewProxy.scrollTo(lastItemId, anchor: .leading)
                        }
                    }
                }
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
        }
    }
    
    func rotation(_ proxy: GeometryProxy) -> Double {
        let scrollViewWidth = proxy.bounds(of: .scrollView(axis: .horizontal))?.width ?? 0
        let midX = proxy.frame(in: .scrollView(axis: .horizontal)).midX
        /// Converting into progress
        let progress = midX / scrollViewWidth
        /// Limiting Progress between 0-1
        let cappedProgress = max(min(progress, 1), 0)
        /// Limiting Rotation between 0-90
        let cappedRotation = max(min(rotation, 90), 0)
        let degree = cappedProgress * (cappedRotation * 2)
        
        return cappedRotation - degree
    }
}

struct CardFlowItem: Identifiable, Equatable {
    let id: UUID = .init()
    var name: String
    var name2: String
    var city: Int
    var userID: String
    var ageRange: String
    var industry: String
    var hobbies: [String]
    
    init(name: String, name2: String, city: Int, userID: String, ageRange: String, industry: String, hobbies: [String]) {
        self.name = name
        self.name2 = name2
        self.city = city
        self.userID = userID
        self.ageRange = ageRange
        self.industry = industry
        self.hobbies = hobbies
    }
    
    init(connectedUser: ConnectedUser) {
        self.name = connectedUser.firstName ?? ""
        self.name2 = connectedUser.surname ?? ""
        self.city = connectedUser.city ?? 1
        self.userID = connectedUser.id
        self.ageRange = connectedUser.ageRange ?? ""
        self.industry = connectedUser.industry ?? ""
        self.hobbies = connectedUser.hobbies ?? ["hobby1", "hobby2"]
    }
    
    static var mock: CardFlowItem {
        CardFlowItem(name: "dan", name2: "crowley", city: 1, userID: "12345", ageRange: "25-34", industry: "tech", hobbies: ["climbing", "hiking"])
    }
}

//#Preview {
//    CardContainerView(height: 120, itemWidth: 120, rolodexState: RolodexState())
//}
