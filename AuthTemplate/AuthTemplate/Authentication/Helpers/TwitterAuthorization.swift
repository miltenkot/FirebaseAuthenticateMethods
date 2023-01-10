//
//  TwitterAuthorization.swift
//  AuthTemplate
//
//  Created by Bartłomiej on 10/01/2023.
//

import Foundation
import FirebaseAuth

extension AuthenticationViewModel {
    func signInWithTwitter() {
        provider.getCredentialWith(nil) { credential, error in
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
}
