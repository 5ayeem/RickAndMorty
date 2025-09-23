//
//  InsightsViewModel.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 22/09/2025.
//

import Foundation
import Combine

@MainActor
final class InsightsViewModel: ObservableObject {
    
    enum Mode: Equatable {
        case idle,
             loading,
             result(String),
             error(String)
    }
    
    private let llm: LLMClient
    private let character: CharacterDetails
    
    @Published var mode: Mode = .idle
    @Published var question: String = ""
    
    init(character: CharacterDetails, llm: LLMClient) {
        self.character = character
        self.llm = llm
    }
    
    func summarize() async {
        await run {
            try await llm.summarize(character)
        }
    }
    
    func funFact() async {
        await run {
            try await llm.funFact(character)
        }
    }
    
    func ask() async {
        let q = question.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return }
        await run {
            try await llm.answer(character, question: q)
        }
    }
    
    private func run(_ work: () async throws -> String) async {
        mode = .loading
        do {
            let text = try await work()
            mode = .result(text)
        } catch {
            mode = .error(error.localizedDescription)
        }
    }
}
