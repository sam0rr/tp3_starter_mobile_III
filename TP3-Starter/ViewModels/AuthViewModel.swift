import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject{
    
    @Published var user: User?
    @Published var isAuthenticated: Bool = false;
    
    private var handle: AuthStateDidChangeListenerHandle?
    
    init(){
        listenToAuthState()
    }
    
    func listenToAuthState(){
        handle = Auth.auth().addStateDidChangeListener({[weak self]_, user in
            Task{
                @MainActor in
                guard let self = self else {return}
                
                self.user = user;
            
                if let user = user {
                    self.isAuthenticated = true

                }else{
                    self.isAuthenticated = false

                }
            }
            
        })
    }
    
    func login(email: String, password: String) async ->Bool{
        do {
            
            _ =  try await  Auth.auth().signIn(withEmail: email, password: password)
            return true;
        }catch{
            return false
        }
    }
    
    func signOut(){
        do{
            try Auth.auth().signOut()
        }catch{
            print("")
        }
    }
    
    func signUp(email: String, password: String, firstname: String, lastname: String) async ->String? {
        do {
            
            let result =  try await  Auth.auth().createUser(withEmail: email, password: password)
            
            let uid = result.user.uid
            
            let db = Firestore.firestore()
            
            try await db.collection("users").document(uid).setData([
           //     "username": username,
                "firstname": firstname,
                "lastname": lastname,
                "email": email,
                "createdData": FieldValue.serverTimestamp()
            ])
            return nil;
        }catch{
            return error.localizedDescription
        }
    }
    
    deinit{
        handle = nil
    }
    
}
