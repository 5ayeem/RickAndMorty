//
//  LLMClient.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 22/09/2025.
//

import Foundation
import NetworkKit

public enum LLMClientError: Error {
    case failed
}

public protocol LLMClient {
    func chat(system: String?, user: String) async throws -> String
}

public final class OpenAIClient: LLMClient {
    private let http: HTTPClient
    private let model: String
    private let temperature: Double
    private let maxTokens: Int

    // MARK: - DTOs
    private struct Msg: Codable {
        let role: String
        let content: String
    }
    
    private struct ChatRequest: Codable {
        let model: String
        let messages: [Msg]
        let temperature: Double
        let max_tokens: Int
    }
    
    private struct ChatResult: Codable {
        struct Choice: Codable {
            let message: Msg
        }
        let choices: [Choice]
    }

    // MARK: - Inits
    public init(
        http: HTTPClient,
        model: String = "gpt-3.5-turbo",
        temperature: Double = 0.3,
        maxTokens: Int = 220
    ) {
        self.http = http
        self.model = model
        self.temperature = temperature
        self.maxTokens = maxTokens
    }

    public convenience init(
        apiKey: String,
        model: String = "gpt-3.5-turbo",
        temperature: Double = 0.3,
        maxTokens: Int = 220
    ) {
        let http = URLSessionHTTPClient(
            baseURL: URL(string: "https://api.openai.com/v1")!,
            defaultHeaders: ["Authorization": "Bearer \(apiKey)"]
        )
        self.init(http: http, model: model, temperature: temperature, maxTokens: maxTokens)
    }

    // MARK: - LLMClient
    public func chat(system: String?, user: String) async throws -> String {
        var messages: [Msg] = []
        if let system, !system.isEmpty {
            messages.append(.init(role: "system", content: system))
        }
        messages.append(.init(role: "user", content: user))

        let request = ChatRequest(
            model: model,
            messages: messages,
            temperature: temperature,
            max_tokens: maxTokens
        )

        let result: ChatResult = try await http.sendJSON(
            path: "/chat/completions",
            method: .POST,
            headers: ["Content-Type": "application/json"],
            body: request
        )

        return result.choices.first?.message.content
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
}
