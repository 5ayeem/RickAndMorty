//
//  MockCharactersRepository.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 23/09/2025.
//

@testable import RickAndMorty
import Foundation

final class MockCharactersRepository: CharactersRepository {
    
    var nextPageResult: Result<[CharacterSummary], Error> = .success([])
    var nextDetailsResult: Result<CharacterDetails, Error> = .failure(NSError(domain: "Mock", code: -1))

    private(set) var lastRequestedPage: Int?
    private(set) var lastRequestedID: String?

    func page(_ page: Int) async throws -> [CharacterSummary] {
        lastRequestedPage = page
        return try nextPageResult.get()
    }

    func details(id: String) async throws -> CharacterDetails {
        lastRequestedID = id
        return try nextDetailsResult.get()
    }
}
