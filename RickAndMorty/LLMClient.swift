//
//  LLMClient.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 22/09/2025.
//

import Foundation

enum LLMClientError: Error {
    case failed
}

protocol LLMClient {
    func summarize(_ c: CharacterDetails) async throws -> String
    func funFact(_ c: CharacterDetails) async throws -> String
    func answer(_ c: CharacterDetails, question: String) async throws -> String
}

final class OpenAIClient: LLMClient {
    
    private let http: HTTPClient
    private let model: String
    
    struct Msg: Codable {
        let role: String
        let content: String
    }
    
    struct ChatRequest: Codable {
        let model: String
        let messages: [Msg]
        let temperature: Double
        let max_tokens: Int
    }
    
    struct ChatResult: Codable {
        struct Choice: Codable {
            let message: Msg
        }
        
        let choices: [Choice]
    }

    init(http: HTTPClient, model: String = "gpt-3.5-turbo") {
        self.http = http
        self.model = model
    }
    
    convenience init(apiKey: String, model: String = "gpt-3.5-turbo") {
        let http = URLSessionHTTPClient(
            baseURL: URL(string: "https://api.openai.com/v1")!,
            defaultHeaders: ["Authorization": "Bearer \(apiKey)"]
        )
        self.init(http: http, model: model)
    }

    func summarize(_ c: CharacterDetails) async throws -> String {
        try await chat(
            system: "You are a helpful assistant inside an iOS app. Be concise and factual.",
            user: """
                  Summarize this Rick & Morty character in 3 bullet points. Mention status, species/type, and a notable episode if present. Keep under 80 words.
                  \(contextJSON(c))
                  """
        )
    }

    func funFact(_ c: CharacterDetails) async throws -> String {
        try await chat(
            system: "You are a playful assistant. Keep answers brief and tied to data given.",
            user: """
                  Give one fun fact about this character, referencing an episode code/title if available. Max 2 sentences.
                  \(contextJSON(c))
                  """
        )
    }

    func answer(_ c: CharacterDetails, question: String) async throws -> String {
        try await chat(
            system: "Answer based only on the provided character data. If unknown, say you’re not sure.",
            user: "Character data:\n\(contextJSON(c))\n\nQuestion: \(question)"
        )
    }

    private func chat(system: String, user: String) async throws -> String {
        let request = ChatRequest(
            model: model,
            messages: [Msg(role: "system", content: system),
                       Msg(role: "user", content: user)],
            temperature: 0.3,
            max_tokens: 220
        )

        let result: ChatResult = try await http.sendJSON(
            path: "/chat/completions",
            method: .POST,
            headers: ["Content-Type": "application/json"],
            body: request
        )
        return result.choices.first?.message.content.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
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
