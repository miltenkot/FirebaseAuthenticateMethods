//
//  LoginOptions.swift
//  AuthTemplate
//
//  Created by Bartłomiej on 05/01/2023.
//

import SwiftUI

struct LoginOptionsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var auth: AuthenticationViewModel
    @StateObject var viewModel = LoginOptionsViewModel()
    
    var body: some View {
        content
    }
    
    var content: some View {
        VStack {
            Button {
                viewModel.emailAuthIsPresented.toggle()
            } label: {
                Text("Sign in with Email")
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
            .padding()
            .sheet(isPresented: $viewModel.emailAuthIsPresented, onDismiss: {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                    dismiss()
                }
            }) {
                AuthenticationView()
                    .environmentObject(auth)
            }
        }
    }
}

struct LoginOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        LoginOptionsView()
    }
}
