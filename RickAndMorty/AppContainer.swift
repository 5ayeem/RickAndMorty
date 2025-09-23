//
//  AppContainer.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 22/09/2025.
//

import Foundation

protocol AppContainer {
    
    func createCharactersViewModel() -> CharactersViewModel
    func createCharacterDetailsViewModel(id: String) -> CharacterDetailsViewModel
}

final class DefaultAppContainer: AppContainer {
    
    private let network: GraphQLNetworking
    private let charactersRepo: CharactersRepository
    private let llmClientFactory: LLMClientFactory = .init()

    init(
        endpoint: URL = URL(string: "https://rickandmortyapi.com/graphql")!,
        networkBuilder: (URL) -> GraphQLNetworking = { DefaultGraphQLNetworking(endpoint: $0) }
    ) {
        self.network = networkBuilder(endpoint)
        self.charactersRepo = DefaultCharactersRepository(network: network)
    }
    
    func createCharactersViewModel() -> CharactersViewModel {
        CharactersViewModel(repo: charactersRepo, container: self)
    }
    
    func createCharacterDetailsViewModel(id: String) -> CharacterDetailsViewModel {
        CharacterDetailsViewModel(id: id, repo: charactersRepo, llm: llmClientFactory.llm)
    }
}
