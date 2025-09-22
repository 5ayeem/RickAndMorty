//
//  ViewModel.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 19/09/2025.
//

import Foundation
import Combine

@MainActor
final class CharactersViewModel: ObservableObject {
    private let repo: CharactersRepository

    @Published var characters: [CharacterSummary] = []
    @Published var loading = false
    @Published var errorMessage: String?

    init(repo: CharactersRepository) {
        self.repo = repo
    }

    func load(page: Int = 1) async {
        loading = true; defer { loading = false }
        do {
            characters = try await repo.page(page)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
