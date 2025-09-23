//
//  CharacterDetails.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 22/09/2025.
//

import Foundation

struct CharacterDetails: Identifiable, Equatable {
    let id: String
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let originName: String
    let locationName: String
    let imageURL: URL?
    let episodes: [EpisodeSummary]
    let createdAtISO: String
}

extension CharacterDetails {
    var createdAtFormatted: String {
        DateFormatting.longUS(fromISO: createdAtISO) ?? createdAtISO
    }
}

struct EpisodeSummary: Identifiable, Equatable {
    let id: String
    let name: String
    let code: String
    let airDate: String
}
