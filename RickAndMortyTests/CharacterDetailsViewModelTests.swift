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
    var service: MockInsightsService!
    
    override func setUpWithError() throws {
        self.repo = MockCharactersRepository()
        self.service = MockInsightsService()
    }
    
    override func tearDownWithError() throws {
        self.repo = nil
        self.service = nil
    }

    func test_load_success_setsDetails_andTurnsOffLoading() async {
        // Given
        let details = CharacterDetails.stub(
            id: "361", name: "Toxic Rick", status: "Dead",
            species: "Humanoid", type: "Rick's Toxic Side",
            originName: "Alien Spa", locationName: "Earth"
        )
        repo.nextDetailsResult = Result<CharacterDetails, Error>.success(details)

        let sut = CharacterDetailsViewModel(
            id: "361",
            repo: repo,
            insightsService: service
        )
        
        // When
        await sut.load()
        
        // Then
        XCTAssertEqual(repo.lastRequestedID, "361")
        XCTAssertEqual(sut.details?.name, "Toxic Rick")
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.loading)
    }

    func test_load_failure_setsError_andLeavesDetailsNil() async {
        // Given
        repo.nextDetailsResult = .failure(TestError())

        let sut = CharacterDetailsViewModel(
            id: "X",
            repo: repo,
            insightsService: service
        )
        
        // When
        await sut.load()
        
        // Then
        XCTAssertNil(sut.details)
        XCTAssertEqual(sut.errorMessage, "error!")
        XCTAssertFalse(sut.loading)
    }
}
