//
//  InsightsViewModelTests.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 23/09/2025.
//

import XCTest
@testable import RickAndMorty

@MainActor
final class InsightsViewModelTests: XCTestCase {
    
    struct TestError: LocalizedError {
        var errorDescription: String? { "Rate limited" }
    }

    func test_summarize_success_setsResult_andTracksInput() async {
        // Given
        let c = CharacterDetails.stub()
        let llm = MockLLMClient()
        llm.summarizeResult = .success("• Alive human.")

        let vm = InsightsViewModel(character: c, llm: llm)
        
        // When
        await vm.summarize()
        
        // Then
        if case .result(let text) = vm.mode {
            XCTAssertEqual(text, "• Alive human.")
        } else {
            XCTFail("Expected .result")
        }
        XCTAssertEqual(llm.lastSummarized?.id, c.id)
    }

    func test_funFact_error_setsError() async {
        // Given
        let c = CharacterDetails.stub()
        let llm = MockLLMClient()
        llm.funFactResult = .failure(TestError())

        let vm = InsightsViewModel(character: c, llm: llm)
        
        // When
        await vm.funFact()
        
        // Then
        if case .error(let msg) = vm.mode {
            XCTAssertTrue(msg.contains("Rate limited"))
        } else {
            XCTFail("Expected .error")
        }
    }

    func test_ask_trimsQuestion_andPassesToLLM() async {
        // Given
        let c = CharacterDetails.stub()
        let llm = MockLLMClient()
        llm.answerResult = .success("Because reasons.")

        let vm = InsightsViewModel(character: c, llm: llm)
        vm.question = "   Why is he popular?   "
        
        // When
        await vm.ask()
        
        // Then
        if case .result(let text) = vm.mode {
            XCTAssertEqual(text, "Because reasons.")
        } else {
            XCTFail("Expected .result")
        }
        XCTAssertEqual(llm.lastAnswerInput?.question, "Why is he popular?")
        XCTAssertEqual(llm.lastAnswerInput?.character.id, c.id)
    }
}
