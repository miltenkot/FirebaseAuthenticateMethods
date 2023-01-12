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
    @Environment(\.showingSheet) var showingSheet
    @EnvironmentObject var authVM: AuthenticationViewModel
    @StateObject var viewModel = LoginOptionsViewModel()
    
    var body: some View {
        content
    }
    
    var content: some View {
        ScrollView {
            VStack {
                Group {
                    signInWithPhone
                    singInWithEmail
                    signInWithApple
                    signInWithGoogle
                    signInWithFacebook
                    signInWithTwitter
                    signInWithGitHub
                    signInWithMicrosoft
                    signInWithYahoo
                }
                .padding()
            }
        }
    }
    
}

// MARK: Buttons
extension LoginOptionsView {
    var signInWithPhone: some View {
        Button {
            viewModel.phoneAuthIsPresented.toggle()
        } label: {
            Text("Sign in with Phone")
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
        }
        .frame(width: 350, height: 50)
        .buttonStyle(.borderedProminent)
        .padding(.top, 50)
        .sheet(isPresented: $viewModel.phoneAuthIsPresented, onDismiss: {
            Task {
                try await Task.sleep(for: .milliseconds(1))
                await MainActor.run(body: {
                    showingSheet?.wrappedValue = false
                })
            }
        }) {
            PhoneSignInView()
                .environmentObject(authVM)
        }
    }
    
    var singInWithEmail: some View {
        Button {
            viewModel.emailAuthIsPresented.toggle()
        } label: {
            Text("Sign in with Email")
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
        }
        .frame(width: 350, height: 50)
        .buttonStyle(.borderedProminent)
        .sheet(isPresented: $viewModel.emailAuthIsPresented, onDismiss: {
            Task {
                try await Task.sleep(for: .milliseconds(1))
                await MainActor.run(body: {
                    showingSheet?.wrappedValue = false
                })
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
        .frame(width: 350, height: 50)
        .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
        .cornerRadius(8)
    }
    
    var signInWithGoogle: some View {
        GoogleSignInButton {
            authVM.signInWithGoogle()
        }
        .frame(width: 350, height: 50)
    }
    
    var signInWithFacebook: some View {
        FacebookSignInView()
            .frame(width: 350, height: 50)
    }
    
    var signInWithTwitter: some View {
        Button {
            authVM.signInWithTwitter()
        } label: {
            Text("Sign in with Twitter")
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
        }
        .frame(width: 350, height: 50)
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
        .frame(width: 350, height: 50)
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
        .frame(width: 350, height: 50)
        .tint(.green)
        .buttonStyle(.borderedProminent)
    }
    
    var signInWithYahoo: some View {
        Button {
            authVM.signInWithYahoo()
        } label: {
            Text("Sign in with Yahoo")
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
        }
        .frame(width: 350, height: 50)
        .tint(.purple)
        .buttonStyle(.borderedProminent)
    }
}

struct LoginOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        LoginOptionsView()
    }
}
