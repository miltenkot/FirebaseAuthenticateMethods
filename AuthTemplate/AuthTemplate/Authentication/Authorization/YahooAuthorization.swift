//
//  YahooAuthorization.swift
//  AuthTemplate
//
//  Created by Bartłomiej on 12/01/2023.
//

import Foundation
import FirebaseAuth

extension AuthenticationViewModel {
    func signInWithYahoo() {
        //yahooProvider.scopes = ["mail-r"]
        yahooProvider.getCredentialWith(nil) { [unowned self] credential, error in
            authorize(credential: credential, error: error)
        }
    }
}
