//
//  AuthenticationView.swift
//  AuthTemplate
//
//  Created by Bartłomiej on 06/01/2023.
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel
    
    var body: some View {
        VStack {
            switch authVM.flow {
            case .login:
                EmailSignInView()
                    .environmentObject(authVM)
            case .signUp:
                EmailSignUpView()
                    .environmentObject(authVM)
            }
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
            .environmentObject(AuthenticationViewModel())
    }
}
