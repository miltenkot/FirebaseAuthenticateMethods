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
        twitterProvider.getCredentialWith(nil) { [unowned self] credential, error in
            authorize(credential: credential, error: error)
        }
    }
}
