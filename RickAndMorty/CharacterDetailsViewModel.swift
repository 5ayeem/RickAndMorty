//
//  CharacterDetailsViewModel.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 22/09/2025.
//

import Foundation
import Combine

@MainActor
final class CharacterDetailsViewModel: ObservableObject {
    private let repo: CharactersRepository
    private let id: String
    let llm: LLMClient

    @Published var details: CharacterDetails?
    @Published var loading = false
    @Published var errorMessage: String?

    init(id: String, repo: CharactersRepository, llm: LLMClient) {
        self.id = id
        self.repo = repo
        self.llm = llm
    }

    func load() async {
        loading = true; defer { loading = false }
        do {
            details = try await repo.details(id: id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
