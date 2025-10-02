import Foundation
import FirebaseAuth

@Observable
final class AuthService {
    
    static let shared = AuthService()
    var currentUser: FirebaseAuth.User?
    private let auth = Auth.auth()
    
    private init() {
        currentUser = auth.currentUser
    }
    
    func registerWithEmail(email: String, password: String) async throws {
        let result = try await auth.createUser(withEmail: email, password: password)
        currentUser = result.user
    }
    
    func signInWithEmail(email: String, password: String) async throws {
        let result = try await auth.signIn(withEmail: email, password: password)
        currentUser = result.user
        
    }
    
    func signOut() throws {
        try auth.signOut()
        currentUser = nil
    }
}
