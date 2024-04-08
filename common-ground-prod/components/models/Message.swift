//
//  File.swift
//  common-ground-prod
//
//  Created by dan crowley on 3/22/24.
//

import Foundation





// Dummy data for the InboxView
struct DummyMessage {
    let senderName: String
    let message: String
    let timeAgo: String
    let unread: Bool
}

extension DummyMessage {
    static let dummyData: [DummyMessage] = [
        DummyMessage(senderName: "John Doe", message: "Hey there!", timeAgo: "2h", unread: Bool.random()),
        DummyMessage(senderName: "ANNE C", message: "I honestly couldn’t tell you the name it was some kid all messed up on meds after wisdom teeth?", timeAgo: "1d", unread: Bool.random()),
        DummyMessage(senderName: "DENNIS C", message: "He can’t stand his “gee wiz” theater kid energy and the ostensible adults who claim seeing one of his plays was the most powerful experience ever", timeAgo: "3d", unread: Bool.random()),
        DummyMessage(senderName: "COLEMAN D", message: "I’d love to know how your cousin feels about Catholic guilt. The cousin who left the seminary with a nun-in-training to invent the Tide to go pen", timeAgo: "5d", unread: Bool.random()),
        DummyMessage(senderName: "Michael D", message: " FINAlly got the Tide to go pen .. Call me when you're free!", timeAgo: "1w", unread: Bool.random()),
        DummyMessage(senderName: "Sophia W", message: "Wait i like polite men too… ? So maybe we are quite similar. Adding u on whatsapp now queen ", timeAgo: "2w", unread: Bool.random()),
        DummyMessage(senderName: "Oliver M", message: "yoo was your weekend? i literaly lost everything bro. pelase call me", timeAgo: "2w", unread: Bool.random()),
        DummyMessage(senderName: "Charlotte C", message: "Did you get my email? mom died. its time to come home", timeAgo: "3w", unread: Bool.random()),
        DummyMessage(senderName: "William Th", message: "do u still have that blow deal;ers number or nah", timeAgo: "4w", unread: Bool.random()),
        DummyMessage(senderName: "Ella H", message: "Can you help me with this? Please i need help now theyre coming ", timeAgo: "1mo", unread: Bool.random()),
    ]
}
//
//let message1 = Message(messageId: 1, senderId: "sender1", recipientId: "recipient1", text: "Hello!", timestamp: Date(), favorite: false)
//let message2 = Message(messageId: 2, senderId: "recipient1", recipientId: "sender1", text: "Hi there!", timestamp: Date().addingTimeInterval(60), favorite: true)
//let message3 = Message(messageId: 3, senderId: "sender1", recipientId: "recipient1", text: "How are you?", timestamp: Date().addingTimeInterval(120), favorite: false)
//let message4 = Message(messageId: 4, senderId: "recipient1", recipientId: "sender1", text: "U really cant wear cole haan saddle shoes in Bushwick safely 🤓 ", timestamp: Date().addingTimeInterval(180), favorite: true)
//let message5 = Message(messageId: 5, senderId: "recipient1", recipientId: "recipient1", text: "The one on left looks pretty Jewish looking!", timestamp: Date().addingTimeInterval(240), favorite: false)
//let message6 = Message(messageId: 6, senderId: "sender1", recipientId: "sender1", text: "he's not. P sure he's just hispanic or spanosh or smthn lol", timestamp: Date().addingTimeInterval(300), favorite: true)
//let message7 = Message(messageId: 7, senderId: "sender1", recipientId: "sender1", text: "if the police call tell them im not home ", timestamp: Date().addingTimeInterval(1000), favorite: false)
//let message8 = Message(messageId: 8, senderId: "sender1", recipientId: "sender1", text: " blink twice if u get this ", timestamp: Date().addingTimeInterval(1200), favorite: false)
//
//
//// Create a fake conversation using the generated messages
//let fakeConversation = Conversation(senderName: "jinni", messages: [message1, message2, message3, message4, message5, message6, message7, message8], timeAgo: "5h")
