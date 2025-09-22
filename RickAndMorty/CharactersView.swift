//
//  CharactersView.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 19/09/2025.
//

import SwiftUI

struct CharactersView: View {
    
    @StateObject var viewModel: CharactersViewModel
    
    private let columns: Int

    init(viewModel: CharactersViewModel, columns: Int = 2) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.columns = max(1, columns)
    }

    private var gridLayout: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 12), count: columns)
    }

    var body: some View {
        ScrollView {
            if let err = viewModel.errorMessage {
                Text("Error: \(err)")
                    .foregroundColor(.red)
                    .padding()
            }

            LazyVGrid(columns: gridLayout, spacing: 12) {
                ForEach(viewModel.characters) { character in
                    CharacterTile(character: character)
                }
            }
            .padding(12)
        }
        .overlay { if viewModel.loading { ProgressView() } }
        .navigationTitle("Characters")
        .task { await viewModel.load() }
    }
}

private struct CharacterTile: View {
    let character: CharacterSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: character.imageURL) { phase in
                switch phase {
                case .success(let img):
                    img.resizable()
                        .scaledToFill()
                case .failure(_):
                    ZStack {
                        Rectangle().fill(Color.secondary.opacity(0.2))
                        Image(systemName: "photo")
                            .imageScale(.large)
                            .foregroundColor(.secondary)
                    }
                case .empty:
                    ZStack {
                        Rectangle().fill(Color.secondary.opacity(0.1))
                        ProgressView()
                    }
                @unknown default:
                    fatalError()
                }
            }
            .aspectRatio(1, contentMode: .fill)
            .clipped()

            VStack(alignment: .leading, spacing: 2) {
                Text(character.name)
                    .font(.headline)
                    .lineLimit(1)
                Text(character.status)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.black.opacity(0.05), lineWidth: 0.5)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
}

