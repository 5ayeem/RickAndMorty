//
//  CharacterDetailsViewModelTests.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 23/09/2025.
//

import XCTest
@testable import RickAndMorty

@MainActor
final class CharacterDetailsViewModelTests: XCTestCase {
    
    struct TestError: LocalizedError {
        var errorDescription: String? { "error!" }
    }
    
    var repo: MockCharactersRepository!
    var llm: MockLLMClient!
    
    override func setUpWithError() throws {
        self.repo = MockCharactersRepository()
        self.llm = MockLLMClient()
    }
    
    override func tearDownWithError() throws {
        self.repo = nil
        self.llm = nil
    }

    func test_load_success_setsDetails_andTurnsOffLoading() async {
        // Given
        let details = CharacterDetails.stub(
            id: "361", name: "Toxic Rick", status: "Dead",
            species: "Humanoid", type: "Rick's Toxic Side",
            originName: "Alien Spa", locationName: "Earth"
        )
        repo.nextDetailsResult = Result<CharacterDetails, Error>.success(details)

        let vm = CharacterDetailsViewModel(id: "361", repo: repo, llm: llm)
        
        // When
        await vm.load()
        
        // Then
        XCTAssertEqual(repo.lastRequestedID, "361")
        XCTAssertEqual(vm.details?.name, "Toxic Rick")
        XCTAssertNil(vm.errorMessage)
        XCTAssertFalse(vm.loading)
    }

    func test_load_failure_setsError_andLeavesDetailsNil() async {
        // Given
        repo.nextDetailsResult = .failure(TestError())

        let vm = CharacterDetailsViewModel(id: "X", repo: repo, llm: llm)
        
        // When
        await vm.load()
        
        // Then
        XCTAssertNil(vm.details)
        XCTAssertEqual(vm.errorMessage, "error!")
        XCTAssertFalse(vm.loading)
    }
}
