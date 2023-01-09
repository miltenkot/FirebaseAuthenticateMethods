//
//  AuthTemplateApp.swift
//  AuthTemplate
//
//  Created by Bartłomiej on 05/01/2023.
//

import SwiftUI
import Firebase
import FacebookCore
import FacebookLogin
import FirebaseAuth
import FBSDKCoreKit

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
        
        configureFirebase()
        configureFacebookSDK(application: application, launchOptions: launchOptions)
        return true
    }
    
    func application(
            _ app: UIApplication,
            open url: URL,
            options: [UIApplication.OpenURLOptionsKey : Any] = [:]
        ) -> Bool {
            ApplicationDelegate.shared.application(
                app,
                open: url,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )
        }
}

extension AppDelegate {
    private func configureFirebase() {
        FirebaseApp.configure()
    }
    
    private func configureFacebookSDK(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) {
        FBSDKCoreKit.ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
    }
}
