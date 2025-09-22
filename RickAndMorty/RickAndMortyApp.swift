//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 19/09/2025.
//

import SwiftUI

@main
struct RickAndMortyApp: App {
    
    private let container = AppContainer()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                CharactersView(viewModel: .init(repo: container.charactersRepo))
            }
        }
    }
}
