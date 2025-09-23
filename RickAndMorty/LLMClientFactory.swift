//
//  LLMClientFactory.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 23/09/2025.
//

import LLMKit

final class LLMClientFactory {
    
    private let llmKey: String = "" // Paste key here for testing
    
    lazy var llm: LLMClient = {
        if !llmKey.isEmpty {
            return OpenAIClient(apiKey: llmKey)
        } else {
            return MockLLMClient()
        }
    }()
    
    // Should use this way. But using above impl as its quick to test
    /*
    let llm: LLMClient = {
        if let key = Bundle.main.infoDictionary?["OpenAIAPIKey"] as? String, !key.isEmpty {
            return OpenAIClient(apiKey: llmKey)
        } else {
            return MockLLMClient()
        }
    }()
     */
}
