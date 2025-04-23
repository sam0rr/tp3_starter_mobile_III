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
    

    func addFriend(uid: String) async {
        guard let userId = currentUserId else { return }
        
        guard let friend = searchResult.first(where: { $0.uid == uid }) else { return }
        
        do {
            try await
            db.collection("users").document(userId).collection("friends")
                .document(friend.uid)
                .setData([
                    "username": friend.username,
                    "firstName": friend.firstname,
                    "lastName": friend.lastname
                ])
        } catch {
            print("Error adding friend: \(error)")
        }
    }
    
    func fetchFriends() async {
        guard let userId = currentUserId else { return }
        
        do {
            let snapshot = try await
            db.collection("users").document(userId).collection("friends")
                .getDocuments()
            
            let fetchedFriends: [Friend] = snapshot.documents.compactMap { doc in
                let data = doc.data()
                
                guard
                    let username = data["username"] as? String,
                    let firstName = data["firstName"] as? String,
                    let lastName = data["lastName"] as? String
                else { return nil }
                
                return Friend(
                    uid: doc.documentID,
                    firstname: firstName,
                    lastname: lastName,
                    username: username
                )
            }
            
            DispatchQueue.main.async {
                self.friend = fetchedFriends
            }
        } catch {
            print("Error fetching friends: \(error.localizedDescription)")
        }
    }
    
    func searchFriends(search: String) async {
        guard let userId = currentUserId else { return }
        
        do {
            let friendSnapshot = try await db.collection("users").document(userId).collection("friend").getDocuments()
            let friendIds = Set(friendSnapshot.documents.map { $0.documentID })
            
            let snapshot = try await db.collection("users")
                .whereField("username", isEqualTo: search.lowercased())
                .getDocuments()
            
            DispatchQueue.main.async {
                self.searchResult = snapshot.documents.compactMap { doc in
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
            }
        } catch {
            print("Search failed: \(error.localizedDescription)")
        }
    }
}
