import Foundation
import FirebaseAuth

// MARK: - FirebaseAuthClient

// Handles Firebase authentication and user session state
@Observable
final class FirebaseAuthClient {

    // MARK: - Shared Instance

    static let shared = FirebaseAuthClient()

    // MARK: - Current User

    // Holds the currently authenticated Firebase user
    var currentUser: FirebaseAuth.User?

    private let auth = Auth.auth()

    // MARK: - Initialization

    // Loads existing user session if available
    private init() {
        currentUser = auth.currentUser
    }

    // MARK: - Register

    // Creates a new user with email and password
    func registerWithEmail(email: String, password: String) async throws {
        let result = try await auth.createUser(withEmail: email, password: password)
        currentUser = result.user
    }

    // MARK: - Sign In

    // Signs in existing user with email and password
    func signInWithEmail(email: String, password: String) async throws {
        let result = try await auth.signIn(withEmail: email, password: password)
        currentUser = result.user
    }

    // MARK: - Sign Out

    // Logs out the current user
    func signOut() throws {
        try auth.signOut()
        currentUser = nil
    }
}
