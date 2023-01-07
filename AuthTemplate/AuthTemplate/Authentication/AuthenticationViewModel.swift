//
//  AuthenticationViewModel.swift
//  AuthTemplate
//
//  Created by Bartłomiej on 05/01/2023.
//

import Foundation
import Firebase
import FirebaseAuth
import Combine
import GoogleSignIn

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

enum AuthenticationFlow {
    case login
    case signUp
}

@MainActor
final class AuthenticationViewModel: ObservableObject {
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var errorMessage = ""
    @Published var user: User?
    @Published var displayName = ""
    @Published var isValid = false
    
    @Published var flow: AuthenticationFlow = .login
    
    // MARK: - Email Credential
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    // MARK: - Google Credentials
    private let clientID = "774711135743-qci94mhlp1bnjg5bq0l8t6rjh438j0g5.apps.googleusercontent.com"
    
    /// GIDConfiguration which used our `clientID`.
    private lazy var configuration: GIDConfiguration = {
        return GIDConfiguration(clientID: clientID)
    }()
    
    // MARK: - AuthStateDidChangeListenerHandle
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    var currentNonce: String?
    
    init() {
        registerAuthStateHandler()
        verifySignInWithAppleAuthenticationState()
        validateSignUpFields()
    }
    
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
                self.displayName = user?.email ?? ""
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        }
        catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteAccount() async -> Bool {
        do {
            try await user?.delete()
            return true
        }
        catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
