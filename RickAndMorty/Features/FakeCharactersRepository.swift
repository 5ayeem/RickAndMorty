//
//  FakeCharactersRepository.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 29/09/2025.
//

import Foundation

final class FakeCharactersRepository: CharactersRepository {
    func page(_ page: Int) async throws -> [CharacterSummary] {
        [
            CharacterSummary(
                id: "1",
                name: "Sam",
                status: "ALive",
                species: "Reptile",
                imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")!
            ),
            CharacterSummary(
                id: "2",
                name: "Bob",
                status: "ALive",
                species: "Reptile",
                imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/5.jpeg")!
            ),
            CharacterSummary(
                id: "3",
                name: "Alice",
                status: "ALive",
                species: "Mammal",
                imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/2.jpeg")!
            ),
            CharacterSummary(
                id: "4",
                name: "Foo",
                status: "Dead",
                species: "Human",
                imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/3.jpeg")!
            ),
            CharacterSummary(
                id: "5",
                name: "Sam",
                status: "ALive",
                species: "Reptile",
                imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/4.jpeg")!
            )
        ]
    }
    
    func details(id: String) async throws -> CharacterDetails {
        CharacterDetails(
            id: "1",
            name: "Sam",
            status: "Alive",
            species: "Reptile",
            type: "human",
            gender: "female",
            originName: "Earth",
            locationName: "Mars",
            imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/4.jpeg")!,
            episodes: [],
            createdAtISO: "4th January 2020"
        )
    }
}
