//
//  HomeView.swift
//  AuthTemplate
//
//  Created by Bartłomiej on 06/01/2023.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var auth: AuthenticationViewModel
    var body: some View {
        TabView {
            Text("Main Content")
                .tabItem {
                    Text("Home")
                }
            UserProfileView()
                .environmentObject(auth)
                .tabItem {
                    Text("Profile")
                }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
