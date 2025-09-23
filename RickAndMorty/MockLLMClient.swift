//
//  MockLLMClient.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 23/09/2025.
//

struct MockLLMClient: LLMClient {
    
    func summarize(_ c: CharacterDetails) async throws -> String {
        "• \(c.name) is a \(c.status.lowercased()) \(c.species).\n• Known as \(c.type.isEmpty ? "a unique variant" : c.type).\n• Last seen around \(c.locationName)."
    }
    
    func funFact(_ c: CharacterDetails) async throws -> String {
        if let ep = c.episodes.first { "Appears in \(ep.code) — “\(ep.name)”." }
        else { "Rarely seen on-screen—keep an eye out!" }
    }
    
    func answer(_ c: CharacterDetails, question: String) async throws -> String {
        "Not sure, but \(c.name) is \(c.status.lowercased()) and from \(c.originName)."
    }
}
