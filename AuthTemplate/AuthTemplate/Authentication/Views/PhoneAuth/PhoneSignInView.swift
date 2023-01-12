//
//  PhoneSignInView.swift
//  AuthTemplate
//
//  Created by Bartłomiej on 12/01/2023.
//

import SwiftUI

struct PhoneSignInView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel
    @State private var isShowingDetailView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Text("Enter Mobile Number")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .padding()
                
                TextField("+1", text: $authVM.phoneNumber)
                    .font(.title2)
                    .frame(maxWidth: UIScreen.main.bounds.width / 2, maxHeight: 60)
                    .keyboardType(.phonePad)
                Button {
                    authVM.handleSignInWithPhone { isFinished in
                        isShowingDetailView = isFinished
                    }
                } label: {
                    if authVM.authenticationState != .authenticating {
                        Text("Send OTP")
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                    }
                }
                .frame(width: 350, height: 50)
                .buttonStyle(.borderedProminent)
                .navigationDestination(isPresented: $isShowingDetailView) {
                    PhoneVerifyView()
                        .environmentObject(authVM)
                }
            }
        }
    }
}

struct PhoneSignInView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneSignInView()
            .environmentObject(AuthenticationViewModel())
    }
}
