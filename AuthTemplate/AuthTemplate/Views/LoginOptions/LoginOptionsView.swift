//
//  LoginOptions.swift
//  AuthTemplate
//
//  Created by Bartłomiej on 05/01/2023.
//

import SwiftUI
import AuthenticationServices

struct LoginOptionsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authVM: AuthenticationViewModel
    @StateObject var viewModel = LoginOptionsViewModel()
    
    var body: some View {
        content
    }
    
    var content: some View {
        VStack {
            Group {
                singInWithEmail
                signInWithApple
            }
            .padding()
        }
    }
    
}

// MARK: Buttons
extension LoginOptionsView {
    var singInWithEmail: some View {
        Button {
            viewModel.emailAuthIsPresented.toggle()
        } label: {
            Text("Sign in with Email")
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
        .buttonStyle(.borderedProminent)
        .sheet(isPresented: $viewModel.emailAuthIsPresented, onDismiss: {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                dismiss()
            }
        }) {
            AuthenticationView()
                .environmentObject(authVM)
        }
    }
    
    var signInWithApple: some View {
        SignInWithAppleButton { request in
            authVM.handleSignInWithAppleRequest(request)
        } onCompletion: { result in
            authVM.handleSignInWithAppleCompletion(result)
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
        .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
        .cornerRadius(8)
    }
}

struct LoginOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        LoginOptionsView()
    }
}
