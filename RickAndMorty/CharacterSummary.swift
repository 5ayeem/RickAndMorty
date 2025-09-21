//
//  CharacterSummary.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 21/09/2025.
//

import Foundation

struct CharacterSummary: Identifiable, Equatable {
    let id: String
    let name: String
    let status: String
    let species: String
    let imageURL: URL?
}
