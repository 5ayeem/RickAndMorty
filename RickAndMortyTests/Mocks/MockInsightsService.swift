//
//  MockInsightsService.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 24/09/2025.
//

@testable import RickAndMorty

final class MockInsightsService: InsightsService {

    // Configure per-test
    var summarizeResult: Result<String, Error> = .success("stub summary")
    var funFactResult: Result<String, Error>   = .success("stub fun fact")
    var answerResult: Result<String, Error>    = .success("stub answer")

    // Optional: capture inputs for assertions
    private(set) var lastSummarized: CharacterDetails?
    private(set) var lastFunFactFor: CharacterDetails?
    private(set) var lastAnswerInput: (character: CharacterDetails, question: String)?

    func summarize(_ c: CharacterDetails) async throws -> String {
        lastSummarized = c
        return try summarizeResult.get()
    }

    func funFact(_ c: CharacterDetails) async throws -> String {
        lastFunFactFor = c
        return try funFactResult.get()
    }

    func answer(_ c: CharacterDetails, question: String) async throws -> String {
        lastAnswerInput = (c, question)
        return try answerResult.get()
    }
}

