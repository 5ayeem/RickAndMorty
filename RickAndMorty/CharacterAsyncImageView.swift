//
//  CharacterAsyncImageView.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 22/09/2025.
//

import SwiftUI

struct CharacterAsyncImageView: View {
    
    let url: URL?
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image.resizable()
                    .scaledToFill()
            case .failure:
                Color.secondary.opacity(0.2)
                    .overlay(Image(systemName: "person.crop.square")
                    .imageScale(.large))
            case .empty:
                Color.secondary.opacity(0.1)
                    .overlay(ProgressView())
            @unknown default:
                fatalError()
            }
        }
        .aspectRatio(1, contentMode: .fill)
        .clipped()
    }
}
