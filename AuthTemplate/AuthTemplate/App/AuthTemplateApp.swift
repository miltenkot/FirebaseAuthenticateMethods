//
//  AuthTemplateApp.swift
//  AuthTemplate
//
//  Created by Bartłomiej on 05/01/2023.
//

import SwiftUI
import Firebase

@main
struct AuthTemplateApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authViewModel =  AuthenticationViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                AuthenticatedView {
                    ContentView()
                        .environmentObject(authViewModel)
                } content: {
                    HomeView()
                        .environmentObject(authViewModel)
                }
            }
            
        }
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
