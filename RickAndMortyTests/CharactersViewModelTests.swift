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
        let container = MockAppContainer()
        let vm = CharactersViewModel(repo: repo, container: container)

        // When
        await vm.load()

        // Then
        XCTAssertEqual(vm.characters, expected)
        XCTAssertFalse(vm.loading)
        XCTAssertNil(vm.errorMessage)
    }

    func test_load_failure_setsError_andKeepsCharactersEmpty() async {
        // Given
        let repo = MockCharactersRepository()
        repo.nextPageResult = .failure(TestError())
        let container = MockAppContainer()
        let vm = CharactersViewModel(repo: repo, container: container)

        // When
        await vm.load()

        // Then
        XCTAssertTrue(vm.characters.isEmpty)
        XCTAssertFalse(vm.loading)
        XCTAssertEqual(vm.errorMessage, "Test error!")
    }
}
