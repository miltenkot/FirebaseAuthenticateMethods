//
//  ContentView.swift
//  AuthTemplate
//
//  Created by Bartłomiej on 05/01/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var auth: AuthenticationViewModel
    @Environment(\.showingSheet) var showingSheet
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        content
    }
    
    var content: some View {
        NavigationView {
            ZStack {
                Color.yellow.ignoresSafeArea()
                VStack {
                    Spacer()
                    Button(action: {
                        viewModel.showingSheet.toggle()
                    }, label: {
                        Text("Get Started")
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                    })
                    .frame(maxWidth: .infinity)
                    .padding()
                    .buttonStyle(.borderedProminent)
                    .sheet(isPresented: $viewModel.showingSheet) {
                        LoginOptionsView()
                            .presentationDetents([.large])
                            .presentationDragIndicator(.visible)
                            .environmentObject(auth)
                            .environment(\.showingSheet, $viewModel.showingSheet)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ShowingSheetKey: EnvironmentKey {
    static let defaultValue: Binding<Bool>? = nil
}

extension EnvironmentValues {
    var showingSheet: Binding<Bool>? {
        get { self[ShowingSheetKey.self] }
        set { self[ShowingSheetKey.self] = newValue }
    }
}
