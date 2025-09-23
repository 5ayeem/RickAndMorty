//
//  MockLLMClient.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 23/09/2025.
//

@testable import RickAndMorty
import Foundation

final class MockLLMClient: LLMClient {
    
    var summarizeResult: Result<String, Error> = .success("• Stub summary line 1\n• Stub summary line 2")
    var funFactResult: Result<String, Error> = .success("Stub fun fact.")
    var answerResult: Result<String, Error> = .success("Stub answer.")

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
