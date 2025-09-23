//
//  MockAppContainer.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 23/09/2025.
//

@testable import RickAndMorty
import Foundation

final class MockAppContainer: AppContainer {
    func createCharactersViewModel() -> CharactersViewModel {
        CharactersViewModel(repo: MockCharactersRepository(), container: self)
    }
    
    func createCharacterDetailsViewModel(id: String) -> CharacterDetailsViewModel {
        CharacterDetailsViewModel(id: "1", repo: MockCharactersRepository(), llm: MockLLMClient())
    }
}

// MARK: - Fixtures

extension CharacterDetails {
    static func stub(
        id: String = "1",
        name: String = "Rick Sanchez",
        status: String = "Alive",
        species: String = "Human",
        type: String = "",
        gender: String = "Male",
        originName: String = "Earth (1111)",
        locationName: String = "england",
        imageURL: URL? = URL(string: "https://example.com/rick.png"),
        episodes: [EpisodeSummary] = [.stub()],
        createdAtISO: String = "2017-11-10T12:00:00Z"
    ) -> CharacterDetails {
        CharacterDetails(
            id: id,
            name: name,
            status: status,
            species: species,
            type: type,
            gender: gender,
            originName: originName,
            locationName: locationName,
            imageURL: imageURL,
            episodes: episodes,
            createdAtISO: createdAtISO
        )
    }
}

extension EpisodeSummary {
    static func stub(
        id: String = "S01E01",
        name: String = "Pilot",
        code: String = "S01E01",
        airDate: String = "2013-12-02"
    ) -> EpisodeSummary {
        EpisodeSummary(id: id, name: name, code: code, airDate: airDate)
    }
}

extension CharacterSummary {
    static func stub(
        id: String = "1",
        name: String = "Rick",
        status: String = "Alive",
        species: String = "Human",
        imageURL: URL? = URL(string: "https://example.com/rick.png")
    ) -> CharacterSummary {
        CharacterSummary(id: id, name: name, status: status, species: species, imageURL: imageURL)
    }
}
