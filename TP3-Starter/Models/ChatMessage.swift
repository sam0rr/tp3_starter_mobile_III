import Foundation

struct ChatMessage: Identifiable, Hashable {
    var id: String
    var text: String
    var senderId: String
    var receiverId: String
    var timestamp: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        lhs.id == rhs.id
    }
}
