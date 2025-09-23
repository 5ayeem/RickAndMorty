//
//  InsightsService.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 23/09/2025.
//

import LLMKit
import Foundation

final class InsightsService {
    
    private let llm: LLMClient
    
    init(llm: LLMClient) {
        self.llm = llm
    }

    func summarize(_ c: CharacterDetails) async throws -> String {
        try await llm.chat(
            system: "You are a helpful assistant inside an iOS app. Be concise and factual.",
            user: """
                  Summarize this Rick & Morty character in 3 bullet points. Mention status, species/type, and a notable episode if present. Keep under 80 words.
                  \(contextJSON(c))
                  """
        )
    }

    func funFact(_ c: CharacterDetails) async throws -> String {
        try await llm.chat(
            system: "You are a playful assistant. Keep answers brief and tied to data given.",
            user: """
                  Give one fun fact about this character, referencing an episode code/title if available. Max 2 sentences.
                  \(contextJSON(c))
                  """
        )
    }

    func answer(_ c: CharacterDetails, question: String) async throws -> String {
        try await llm.chat(
            system: "Answer based only on the provided character data. If unknown, say you’re not sure.",
            user: "Character data:\n\(contextJSON(c))\n\nQuestion: \(question)"
        )
    }

    private func contextJSON(_ c: CharacterDetails) -> String {
        let episodes = c.episodes.map {
            ["id": $0.id, "name": $0.name, "code": $0.code, "airDate": $0.airDate]
        }
        
        let dict: [String: Any] = [
            "id": c.id, "name": c.name, "status": c.status, "species": c.species,
            "type": c.type, "gender": c.gender, "origin": c.originName, "location": c.locationName,
            "episodes": episodes
        ]
        
        if let d = try? JSONSerialization.data(withJSONObject: dict, options: [.sortedKeys]),
           let s = String(data: d, encoding: .utf8) {
            return s
        }
        
        return "\(dict)"
    }
}
