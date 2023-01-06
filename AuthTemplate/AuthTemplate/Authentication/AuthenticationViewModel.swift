//
//  AuthenticationViewModel.swift
//  AuthTemplate
//
//  Created by Bartłomiej on 05/01/2023.
//

import Foundation
import FirebaseAuth
import Combine

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
    
    init() {
        registerAuthStateHandler()
        validateSignUpFields()
    }
    
    func registerAuthStateHandler() {
      if authStateHandler == nil {
        authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
          self.user = user
          self.authenticationState = user == nil ? .unauthenticated : .authenticated
          self.displayName = user?.displayName ?? user?.email ?? ""
        }
      }
    }
    
    func reset() {
      flow = .login
      email = ""
      password = ""
      confirmPassword = ""
    }
    
    func switchFlow() {
      flow = flow == .login ? .signUp : .login
      errorMessage = ""
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

// MARK: - Email/Password authorization
extension AuthenticationViewModel {
    
    func signInWithEmailPassword() async -> Bool {
      authenticationState = .authenticating
      do {
        try await Auth.auth().signIn(withEmail: self.email, password: self.password)
        return true
      }
      catch  {
        print(error)
        errorMessage = error.localizedDescription
        authenticationState = .unauthenticated
        return false
      }
    }
    
    func signUpWithEmailPassword() async -> Bool {
      authenticationState = .authenticating
      do  {
        try await Auth.auth().createUser(withEmail: email, password: password)
        return true
      }
      catch {
        print(error)
        errorMessage = error.localizedDescription
        authenticationState = .unauthenticated
        return false
      }
    }
    
    private func validateSignUpFields() {
        $flow
            .combineLatest($email, $password, $confirmPassword)
            .map { flow, email, password, confirmPassword in
                flow == .login
                ? !(email.isEmpty || password.isEmpty)
                : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty || (password != confirmPassword))
            }
            .assign(to: &$isValid)
    }
}
