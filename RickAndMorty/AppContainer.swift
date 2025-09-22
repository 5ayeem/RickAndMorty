//
//  AppContainer.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 22/09/2025.
//

import Foundation

final class AppContainer {
    let network: GraphQLNetworking
    let charactersRepo: CharactersRepository

    init(
        endpoint: URL = URL(string: "https://rickandmortyapi.com/graphql")!,
        networkBuilder: (URL) -> GraphQLNetworking = { DefaultGraphQLNetworking(endpoint: $0) }
    ) {
        self.network = networkBuilder(endpoint)
        self.charactersRepo = DefaultCharactersRepository(network: network)
    }
}
