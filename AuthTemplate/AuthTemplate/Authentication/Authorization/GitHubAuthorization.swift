//
//  GitHubAuthorization.swift
//  AuthTemplate
//
//  Created by Bartłomiej on 11/01/2023.
//

import Foundation
import FirebaseAuth

extension AuthenticationViewModel {
    func signInWithGitHub() {
        githubProvider.getCredentialWith(nil) { [unowned self] credential, error in
            authorize(credential: credential, error: error)
        }
    }
}
