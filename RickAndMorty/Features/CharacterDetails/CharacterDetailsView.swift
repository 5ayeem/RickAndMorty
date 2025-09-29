//
//  CharacterDetailsView.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 22/09/2025.
//

import SwiftUI

struct CharacterDetailsView: View {
    
    @StateObject var viewModel: CharacterDetailsViewModel

    var body: some View {
        ScrollView {
            if let err = viewModel.errorMessage {
                Text("Error: \(err)")
                    .foregroundColor(.red)
                    .padding()
            }

            if let details = viewModel.details {
                VStack(alignment: .leading, spacing: 16) {
                    CharacterAsyncImageView(url: details.imageURL)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                        )
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(details.name)
                            .font(.largeTitle)
                            .bold()
                        StatusView(details: details)
                        InsightsView(viewModel: .init(character: details, insights: viewModel.insightsService))
                    }

                    InfoPanel(details: details)
                    
                    if !details.episodes.isEmpty {
                        Text("Episodes")
                            .font(.title3)
                            .bold()
                        LazyVStack(alignment: .leading, spacing: 8) {
                            ForEach(details.episodes) { episode in
                                EpisodeCell(episode: episode)
                                    .padding()
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    Color(.secondarySystemBackground)
                                )
                        )
                    }
                }
                .padding()
            }
        }
        .task { await viewModel.load() }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .overlay { if viewModel.loading { ProgressView() } }
    }
}

private struct StatusView: View {
    
    let details: CharacterDetails
    
    var body: some View {
        HStack(spacing: 8) {
            StatusPill(status: details.status)
            Text(details.species)
                .font(.subheadline)
                .foregroundColor(.secondary)
            if !details.type.isEmpty {
                Text(details.type)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

private struct InfoPanel: View {
    
    let details: CharacterDetails
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            InfoCell(
                icon: "person",
                title: "Gender",
                value: details.gender
            )
            InfoCell(
                icon: "globe.americas",
                title: "Origin",
                value: details.originName
            )
        }
        
        HStack(alignment: .top, spacing: 12) {
            InfoCell(
                icon: "mappin.and.ellipse",
                title: "Location",
                value: "\(details.locationName)"
            )
            InfoCell(
                icon: "calendar",
                title: "Created",
                value: "\(details.createdAtFormatted)"
            )
        }
    }
}

private struct InfoCell: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .frame(width: 16)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.caption).foregroundColor(.secondary)
                Text(value).font(.callout)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct EpisodeCell: View {
    
    let episode: EpisodeSummary
    
    var body: some View {
        HStack {
            Text(episode.code)
                .font(.subheadline)
                .monospaced()
            Text(episode.name)
                .font(.body)
            Spacer()
            Text(episode.airDate)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    CharacterDetailsView(viewModel: .init(
            id: "1",
            repo: FakeCharactersRepository(),
            insightsService: DefaultInsightsService(
                llm: MockLLMClient()
            )
        )
    )
}
