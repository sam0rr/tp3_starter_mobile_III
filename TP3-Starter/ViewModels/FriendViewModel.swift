import Foundation
import FirebaseAuth
import FirebaseFirestore

class FriendViewModel: ObservableObject {
    
    @Published var friend: [Friend] = []
    @Published var searchResult: [Friend] = []
    
    private let db = Firestore.firestore()
    
    var currentUserId: String? {
        Auth.auth().currentUser?.uid
    }
    
    func searchFriends(search: String) async {
        guard let userId = currentUserId else { return }
        
        do {
            let friendSnapshot = try await db.collection("users").document(userId).collection("friend").getDocuments()
            let friendIds = Set(friendSnapshot.documents.map { $0.documentID })
            
            let snapshot = try await db.collection("users")
                .whereField("username", isEqualTo: search.lowercased())
                .getDocuments()
            
            searchResult = snapshot.documents.compactMap { doc in
                let userID = doc.documentID
                
                guard userID != userId, !friendIds.contains(userID) else { return nil }
                
                let data = doc.data()
                
                guard
                    let firstname = data["firstname"] as? String,
                    let lastname = data["lastname"] as? String,
                    let username = data["username"] as? String
                else { return nil }
                
                return Friend(
                    uid: userID,
                    firstname: firstname,
                    lastname: lastname,
                    username: username
                )
            }
        } catch {
            print("Search failed: \(error.localizedDescription)")
        }
    }
}
