//
//  GoogleAuthorization.swift
//  AuthTemplate
//
//  Created by Bartłomiej on 07/01/2023.
//

import Foundation
import GoogleSignIn
import Firebase

extension AuthenticationViewModel {
    func signInWithGoogle() {
        guard let rootViewController = UIApplication.keyWindow?.rootViewController else {
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let user = result?.user,
                  let idTokenString = user.idToken?.tokenString else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idTokenString, accessToken: user.accessToken.tokenString)
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
