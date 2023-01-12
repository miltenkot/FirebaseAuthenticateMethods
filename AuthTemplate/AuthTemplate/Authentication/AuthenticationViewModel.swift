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
import SwiftUI

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
    
    // MARK: - AuthStateDidChangeListenerHandle
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    var currentNonce: String?
    
    // MARK: - Twitter Provider
    let twitterProvider = OAuthProvider(providerID: "twitter.com")
    let githubProvider = OAuthProvider(providerID: "github.com")
    let microsoftProvider = OAuthProvider(providerID: "microsoft.com")
    
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
    
    // MARK: - Helper function using in custom authorization
    
    func authorize(credential: AuthCredential?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let credential = credential else { return }
        
        Task {
            do {
                try await Auth.auth().signIn(with: credential)
            }
            catch {
                print("Error authenticating: \(error.localizedDescription)")
            }
        }
    }
}
