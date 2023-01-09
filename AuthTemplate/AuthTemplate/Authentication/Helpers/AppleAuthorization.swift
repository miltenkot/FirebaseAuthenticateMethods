//
//  AppleAuthorization.swift
//  AuthTemplate
//
//  Created by Bartłomiej on 06/01/2023.
//

import FirebaseAuth
import AuthenticationServices

// MARK: - Apple authorization

extension AuthenticationViewModel {

  func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
    request.requestedScopes = [.fullName, .email]
    let nonce = randomNonceString()
    currentNonce = nonce
    request.nonce = sha256(nonce)
  }

  func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
    if case .failure(let failure) = result {
      errorMessage = failure.localizedDescription
    }
    else if case .success(let authorization) = result {
      if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
        guard let nonce = currentNonce else {
          fatalError("Invalid state: a login callback was received, but no login request was sent.")
        }
        guard let appleIDToken = appleIDCredential.identityToken else {
          print("Unable to fetdch identify token.")
          return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
          print("Unable to serialise token string from data: \(appleIDToken.debugDescription)")
          return
        }

        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)
        Task {
          do {
            let result = try await Auth.auth().signIn(with: credential)
            await updateDisplayName(for: result.user, with: appleIDCredential)
          }
          catch {
            print("Error authenticating: \(error.localizedDescription)")
          }
        }
      }
    }
  }

  func updateDisplayName(for user: User, with appleIDCredential: ASAuthorizationAppleIDCredential, force: Bool = false) async {
    if let currentDisplayName = Auth.auth().currentUser?.displayName, !currentDisplayName.isEmpty {
      // current user is non-empty, don't overwrite it
    }
    else {
      let changeRequest = user.createProfileChangeRequest()
      changeRequest.displayName = appleIDCredential.displayName()
      do {
        try await changeRequest.commitChanges()
        self.displayName = Auth.auth().currentUser?.displayName ?? ""
      }
      catch {
        print("Unable to update the user's displayname: \(error.localizedDescription)")
        errorMessage = error.localizedDescription
      }
    }
  }

  func verifySignInWithAppleAuthenticationState() {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let providerData = Auth.auth().currentUser?.providerData
    if let appleProviderData = providerData?.first(where: { $0.providerID == "apple.com" }) {
      Task {
        do {
          let credentialState = try await appleIDProvider.credentialState(forUserID: appleProviderData.uid)
          switch credentialState {
          case .authorized:
            break // The Apple ID credential is valid.
          case .revoked, .notFound:
            // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
            self.signOut()
          default:
            break
          }
        }
        catch {
        }
      }
    }
  }

}

extension ASAuthorizationAppleIDCredential {
  func displayName() -> String {
    return [self.fullName?.givenName, self.fullName?.familyName]
      .compactMap( {$0})
      .joined(separator: " ")
  }
}
