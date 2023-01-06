//
//  EmailAuthorization.swift
//  AuthTemplate
//
//  Created by Bartłomiej on 06/01/2023.
//

import FirebaseAuth

// MARK: - Email/Password authorization

extension AuthenticationViewModel {
    
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
    
    func validateSignUpFields() {
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
