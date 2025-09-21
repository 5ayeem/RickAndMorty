//
//  CharactersRepository.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 21/09/2025.
//

import Foundation
import RickAndMortyAPI
import Apollo

protocol CharactersRepository {
    func page(_ page: Int) async throws -> [CharacterSummary]
}

final class DefaultCharactersRepository: CharactersRepository {
    private let network: GraphQLNetworking

    init(network: GraphQLNetworking) {
        self.network = network
    }

    func page(_ page: Int) async throws -> [CharacterSummary] {
        let result = try await network.fetch(
            CharactersPageQuery(page: page.toGraphQLNullable),
            cachePolicy: .fetchIgnoringCacheData
        )
        let items = result.data?.characters?.results ?? []
        return items.compactMap { $0?.toSummary }
    }
}

private extension CharactersPageQuery.Data.Characters.Result {
    var toSummary: CharacterSummary {
        CharacterSummary(
            id: id ?? "",
            name: name ?? "Unknown",
            status: status ?? "",
            species: species ?? "",
            imageURL: image.flatMap(URL.init(string:))
        )
    }
}
