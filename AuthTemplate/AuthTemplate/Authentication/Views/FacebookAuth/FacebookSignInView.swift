//
//  FacebookSignInView.swift
//  AuthTemplate
//
//  Created by Bartłomiej on 09/01/2023.
//

import SwiftUI
import FirebaseAuth
import FBSDKLoginKit

struct FacebookSignInView: UIViewRepresentable {
    static var currentNonce: String?
    
    func makeCoordinator() -> FacebookSignInView.Coordinator { FacebookSignInView.Coordinator() }
    
    class Coordinator: NSObject, LoginButtonDelegate {
        func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let idTokenString = AuthenticationToken.current?.tokenString else { return }
            let nonce = currentNonce
            let credential = OAuthProvider.credential(withProviderID: "facebook.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            Task {
                do {
                    try await Auth.auth().signIn(with: credential)
                }
                catch {
                    print("Error authenticating: \(error.localizedDescription)")
                }
            }
            
        }
        
        func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
            do {
                try Auth.auth().signOut()
            } catch {
                print("Sign Out error")
            }
        }
    }
    
    func makeUIView(context: UIViewRepresentableContext<FacebookSignInView>) -> FBLoginButton {
        let nonce = randomNonceString()
        FacebookSignInView.currentNonce = nonce
        
        let button = FBLoginButton()
        button.permissions = ["email"]
        button.delegate = context.coordinator
        button.loginTracking = .limited
        button.nonce = sha256(nonce)
        return button
    }
    
    func updateUIView(_ uiView: FBLoginButton, context: UIViewRepresentableContext<FacebookSignInView>) { }
}
