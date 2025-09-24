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

    // MARK: - Tests

    func testSummarize_success_setsResultMode() async throws {
        // Given
        let (vm, service) = makeSUT()
        service.summarizeResult = .success("Summary")
        
        // When
        await vm.summarize()
        
        // Then
        guard case .result(let text) = vm.mode else {
            return XCTFail("Expected .result, got \(vm.mode)")
        }
        XCTAssertEqual(text, "Summary")
    }

    func testFunFact_success_setsResultMode() async throws {
        // Given
        let (vm, service) = makeSUT()
        service.funFactResult = .success("Fun")
        
        // When
        await vm.funFact()
        
        // Then
        guard case .result(let text) = vm.mode else {
            return XCTFail("Expected .result, got \(vm.mode)")
        }
        XCTAssertEqual(text, "Fun")
    }

    func testAsk_success_setsResultMode() async throws {
        // Given
        let (vm, service) = makeSUT()
        service.answerResult = .success("Ask")
        vm.question = "Why is he popular?"
        
        // When
        await vm.ask()
        
        // Then
        guard case .result(let text) = vm.mode else {
            return XCTFail("Expected .result, got \(vm.mode)")
        }
        XCTAssertEqual(text, "Ask")
    }

    func testAsk_ignoresEmptyQuestion_doesNotChangeMode() async {
        // Given
        let (vm, _) = makeSUT()
        vm.question = "   " // only whitespace
        
        // When
        await vm.ask()
        
        // Then
        // Should remain idle (no transition to .loading/.result/.error)
        XCTAssertEqual(vm.mode, .idle)
    }

    func testSummarize_failure_setsErrorMode() async {
        enum TestError: LocalizedError {
            case failed
            var errorDescription: String? { "failed" }
        }
        
        // Given
        let (vm, service) = makeSUT()
        service.summarizeResult = .failure(TestError.failed)
        
        // When
        await vm.summarize()
        
        // Then
        if case .error(let message) = vm.mode {
            XCTAssertEqual(message, "failed")
        } else {
            XCTFail("Expected .error, got \(vm.mode)")
        }
    }
}

// MARK: - Fixtures
extension InsightsViewModelTests {
    private func makeSUT() -> (InsightsViewModel, MockInsightsService) {
        let service = MockInsightsService()
        let vm = InsightsViewModel(character: CharacterDetails.stub(), insights: service)
        return (vm, service)
    }
}
