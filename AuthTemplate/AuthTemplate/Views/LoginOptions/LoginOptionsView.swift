//
//  LoginOptions.swift
//  AuthTemplate
//
//  Created by Bartłomiej on 05/01/2023.
//

import SwiftUI
import AuthenticationServices
import GoogleSignInSwift

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
                signInWithGoogle
                signInWithFacebook
                signInWithTwitter
                signInWithGitHub
                signInWithMicrosoft
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
    
    var signInWithGoogle: some View {
        GoogleSignInButton {
            authVM.signInWithGoogle()
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
    }
    
    var signInWithFacebook: some View {
        FacebookSignInView()
            .frame(maxWidth: .infinity, maxHeight: 50)
    }
    
    var signInWithTwitter: some View {
        Button {
            authVM.signInWithTwitter()
        } label: {
            Text("Sign in with Twitter")
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
        .buttonStyle(.borderedProminent)
    }
    
    var signInWithGitHub: some View {
        Button {
            authVM.signInWithGitHub()
        } label: {
            Text("Sign in with GitHub")
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
        .tint(.black)
        .buttonStyle(.borderedProminent)
        
    }
    
    var signInWithMicrosoft: some View {
        Button {
            authVM.signInWithMicrosoft()
        } label: {
            Text("Sign in with Microsoft")
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
        .tint(.green)
        .buttonStyle(.borderedProminent)
        
    }
}

struct LoginOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        LoginOptionsView()
    }
}
