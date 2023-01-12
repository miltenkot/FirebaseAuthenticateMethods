//
//  PhoneAuthorization.swift
//  AuthTemplate
//
//  Created by Bartłomiej on 12/01/2023.
//

import Foundation
import FirebaseAuth

extension AuthenticationViewModel {
    func handleSignInWithPhone(_ completion: @escaping (Bool) -> Void) {
        authenticationState = .authenticating
        PhoneAuthProvider.provider()
          .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [unowned self] verificationId, error in
              if let error = error {
                  print(error.localizedDescription)
                  authenticationState = .unauthenticated
                  return
              }
              UserDefaults.standard.set(verificationId, forKey: "verificationId")
              completion(true)
          }
    }
    
    func verifyCode(_ completion: @escaping () -> Void) {
        guard let verificationID = UserDefaults.standard.string(forKey: "verificationId") else { return }
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode)
        authorize(credential: credential, error: nil, completion: completion)
    }
}
