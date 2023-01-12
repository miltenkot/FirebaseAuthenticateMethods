//
//  PhoneVerifyView.swift
//  AuthTemplate
//
//  Created by Bartłomiej on 13/01/2023.
//

import SwiftUI

struct PhoneVerifyView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text("Enter SMS Code")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .padding()
            
            TextField("code", text: $authVM.verificationCode)
                .font(.title2)
                .frame(maxWidth: UIScreen.main.bounds.width / 2, maxHeight: 60)
                .keyboardType(.phonePad)
            Button {
                authVM.verifyCode {
                    dismiss()
                }
            } label: {
                Text("Next")
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
            }
            .frame(width: 350, height: 50)
            .buttonStyle(.borderedProminent)
        }
    }
}

struct PhoneVerifyView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneVerifyView()
    }
}
