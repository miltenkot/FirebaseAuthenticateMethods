//
//  MicrosoftAuthorization.swift
//  AuthTemplate
//
//  Created by Bartłomiej on 12/01/2023.
//

import Foundation
import FirebaseAuth

extension AuthenticationViewModel {
    func signInWithMicrosoft() {
        microsoftProvider.getCredentialWith(nil) { [unowned self] credential, error in
            authorize(credential: credential, error: error)
        }
    }
}
