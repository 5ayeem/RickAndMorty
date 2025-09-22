//
//  CharactersRepository.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 21/09/2025.
//

import Foundation
import RickAndMortyAPI
import Apollo

enum CharactersrRepoError: Error {
    case failed
}

protocol CharactersRepository {
    func page(_ page: Int) async throws -> [CharacterSummary]
    func details(id: String) async throws -> CharacterDetails
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
        guard let items = result.data?.characters?.results else {
            throw CharactersrRepoError.failed
        }
        return items.compactMap { $0?.toSummary }
    }
    
    func details(id: String) async throws -> CharacterDetails {
        let result = try await network.fetch(
            CharacterDetailsQuery(id: id),
            cachePolicy: .fetchIgnoringCacheData
        )
        guard let character = result.data?.character else {
            throw CharactersrRepoError.failed
        }
        return character.toDetails
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

private extension CharacterDetailsQuery.Data.Character {
    var toDetails: CharacterDetails {
        CharacterDetails(
            id: id ?? "",
            name: name ?? "Unknown",
            status: status ?? "",
            species: species ?? "",
            type: type ?? "",
            gender: gender ?? "",
            originName: origin?.name ?? "Unknown",
            locationName: location?.name ?? "Unknown",
            imageURL: image.flatMap(URL.init(string:)),
            episodes: episode.compactMap { $0?.toEpisode },
            createdAtISO: created ?? ""
        )
    }
}

private extension CharacterDetailsQuery.Data.Character.Episode {
    var toEpisode: EpisodeSummary {
        EpisodeSummary(
            id: id ?? "",
            name: name ?? "Unknown",
            code: episode ?? "",
            airDate: air_date ?? ""
        )
    }
}
