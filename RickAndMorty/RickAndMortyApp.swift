//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 19/09/2025.
//

import SwiftUI

@main
struct RickAndMortyApp: App {

    private let container = DefaultAppContainer()

    @StateObject private var router = Router()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                CharactersView(
                    viewModel: container.createCharactersViewModel()
                )
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .characterDetails(let id):
                        CharacterDetailsView(
                            viewModel: container.createCharacterDetailsViewModel(id: id)
                        )
                    case .charactersList:
                        CharactersView(
                            viewModel: container.createCharactersViewModel()
                        )
                    }
                }
            }
            .environmentObject(router)
        }
    }
}

