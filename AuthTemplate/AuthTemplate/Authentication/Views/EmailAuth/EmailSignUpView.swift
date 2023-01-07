//
//  EmailSignUpView.swift
//  AuthTemplate
//
//  Created by Bartłomiej on 05/01/2023.
//

import SwiftUI

private enum FocusableField: Hashable {
    case email
    case password
    case confirmPassword
}

struct EmailSignUpView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var focus: FocusableField?
    @State private var imageVariableValue: Double = 0.3
    
    private func signUpWithEmailPassword() {
      Task {
        if await authVM.signUpWithEmailPassword() == true {
          dismiss()
        }
      }
    }
    
    var body: some View {
        content
    }
    
    var content: some View {
        VStack {
            Image(systemName: "rectangle.and.pencil.and.ellipsis", variableValue: imageVariableValue)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minHeight: 50, maxHeight: 100)
            Text("Sign up")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            emailView
                .padding(.vertical, 6)
                .background(Divider(), alignment: .bottom)
                .padding(.bottom, 4)
            
            passwordView
                .padding(.vertical, 6)
                .background(Divider(), alignment: .bottom)
                .padding(.bottom, 8)
            
            confirmPasswordView
                .padding(.vertical, 6)
                .background(Divider(), alignment: .bottom)
                .padding(.bottom, 8)
            
            if !authVM.errorMessage.isEmpty {
              VStack {
                Text(authVM.errorMessage)
                      .foregroundColor(.red)
              }
            }
            
            Button {
                signUpWithEmailPassword()
            } label: {
                if authVM.authenticationState != .authenticating {
                    Text("Sign up")
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                } else {
                    ProgressView()
                      .progressViewStyle(CircularProgressViewStyle(tint: .white))
                      .padding(.vertical, 8)
                      .frame(maxWidth: .infinity)
                }
            }
            .disabled(!authVM.isValid)
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
 
            HStack {
                Text("Already have an account?")
                Button(action: { authVM.switchFlow() }) {
                  Text("Log in")
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                }
            }
            .padding([.top, .bottom], 50)
        }
        .listStyle(.plain)
        .padding()
    }
    
    private var emailView: some View {
        HStack {
            Image(systemName: "at")
            TextField("Email", text: $authVM.email)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .focused($focus, equals: .email)
                .submitLabel(.next)
                .onSubmit {
                    self.imageVariableValue = 0.6
                    self.focus = .password
                }
        }
    }
    
    private var passwordView: some View {
        HStack {
            Image(systemName: "lock")
            SecureField("Password", text: $authVM.password)
                .focused($focus, equals: .password)
                .submitLabel(.next)
                .onSubmit {
                    self.imageVariableValue = 0.9
                    self.focus = .confirmPassword
                }
        }
    }
    
    private var confirmPasswordView: some View {
        HStack {
          Image(systemName: "lock")
          SecureField("Confirm password", text: $authVM.confirmPassword)
            .focused($focus, equals: .confirmPassword)
            .submitLabel(.go)
            .onSubmit {
                signUpWithEmailPassword()
            }
        }
    }
}

struct EmailSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        EmailSignUpView()
            .environmentObject(AuthenticationViewModel())
    }
}
