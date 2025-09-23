//
//  LLMClientFactory.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 23/09/2025.
//

final class LLMClientFactory {
    
    private let llmKey: String = "" // Paste key here for testing
    
    lazy var llm: LLMClient = {
        if !llmKey.isEmpty {
            return OpenAIClient(apiKey: llmKey)
        } else {
            return MockLLMClient()
        }
    }()
}
