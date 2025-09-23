//
//  MockLLMClient.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 23/09/2025.
//

import LLMKit
import Foundation

final class MockLLMClient: LLMClient {

    func chat(system: String?, user: String) async throws -> String {
        // Try to parse the character context JSON embedded in the user prompt
        let ctx = parseContext(from: user)

        // Route by intent (based on your InsightsService prompt templates)
        if user.contains("Summarize this Rick & Morty character") {
            if let ctx { return summarize(ctx) }
            return "• A notable character.\n• Limited data available.\n• Seen across multiple episodes."
        }

        if user.contains("Give one fun fact about this character") {
            if let ctx { return funFact(ctx) }
            return "Appears in a memorable episode."
        }

        if let q = extractQuestion(from: user) {
            if let ctx { return answer(ctx, question: q) }
            return "Not sure based on the given info."
        }

        // Fallback
        return "Mock insight for demo/testing."
    }

    // MARK: - Private helpers

    private struct CharacterCtx: Decodable {
        struct Ep: Decodable { let id: String; let name: String; let code: String; let airDate: String }
        let id: String
        let name: String
        let status: String
        let species: String
        let type: String
        let gender: String
        let origin: String
        let location: String
        let episodes: [Ep]
    }

    private func parseContext(from user: String) -> CharacterCtx? {
        // Find the JSON object by taking the substring between the first '{' and the last '}'.
        guard let start = user.firstIndex(of: "{"),
              let end = user.lastIndex(of: "}") else { return nil }
        let json = String(user[start...end])
        guard let data = json.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(CharacterCtx.self, from: data)
    }

    private func extractQuestion(from user: String) -> String? {
        guard let range = user.range(of: "Question:") else { return nil }
        let q = user[range.upperBound...].trimmingCharacters(in: .whitespacesAndNewlines)
        return q.isEmpty ? nil : q
    }

    private func summarize(_ c: CharacterCtx) -> String {
        let variant = c.type.isEmpty ? "a unique variant" : c.type
        return """
        • \(c.name) is a \(c.status.lowercased()) \(c.species).
        • Known as \(variant).
        • Last seen around \(c.location).
        """
    }

    private func funFact(_ c: CharacterCtx) -> String {
        if let ep = c.episodes.first {
            return "Appears in \(ep.code) — “\(ep.name)”."
        } else {
            return "Rarely seen on-screen—keep an eye out!"
        }
    }

    private func answer(_ c: CharacterCtx, question: String) -> String {
        "Not sure, but \(c.name) is \(c.status.lowercased()) and from \(c.origin)."
    }
}
