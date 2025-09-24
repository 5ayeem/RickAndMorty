//
//  RickAndMortyTests.swift
//  RickAndMortyTests
//
//  Created by Sayeem Hussain on 19/09/2025.
//

import XCTest
@testable import RickAndMorty

@MainActor
final class CharactersViewModelTests: XCTestCase {
    
    struct TestError: LocalizedError {
        var errorDescription: String? { "Test error!" }
    }

    func test_load_success_populatesCharacters_andTurnsOffLoading() async {
        // Given
        let expected: [CharacterSummary] = [
            .init(id: "1", name: "Rick",  status: "Alive", species: "Human",
                  imageURL: URL(string: "https://img/rick.png")),
            .init(id: "2", name: "Morty", status: "Alive", species: "Human",
                  imageURL: nil)
        ]
        let repo = MockCharactersRepository()
        repo.nextPageResult = .success(expected)
        let sut = CharactersViewModel(repo: repo)

        // When
        await sut.load()

        // Then
        XCTAssertEqual(sut.characters, expected)
        XCTAssertFalse(sut.loading)
        XCTAssertNil(sut.errorMessage)
    }

    func test_load_failure_setsError_andKeepsCharactersEmpty() async {
        // Given
        let repo = MockCharactersRepository()
        repo.nextPageResult = .failure(TestError())
        let sut = CharactersViewModel(repo: repo)

        // When
        await sut.load()

        // Then
        XCTAssertTrue(sut.characters.isEmpty)
        XCTAssertFalse(sut.loading)
        XCTAssertEqual(sut.errorMessage, "Test error!")
    }
}
