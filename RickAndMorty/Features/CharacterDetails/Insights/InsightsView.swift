//
//  InsightsView.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 22/09/2025.
//

import SwiftUI

struct InsightsView: View {
    
    @StateObject var viewModel: InsightsViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("AI Insights", systemImage: "sparkles")
                    .font(.headline)
                Spacer()
                Button("Summarize") {
                    Task {
                        await viewModel.summarize()
                    }
                }
                Button("Fun fact") {
                    Task {
                        await viewModel.funFact()
                    }
                }
            }

            HStack(spacing: 8) {
                TextField("Ask a question…", text: $viewModel.question, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                Button {
                    Task {
                        await viewModel.ask()
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                }
                .buttonStyle(.borderedProminent)
                .disabled(
                    viewModel.question.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                )
            }

            Group {
                switch viewModel.mode {
                case .idle:
                    Text("Try “Summarize” or ask a question.")
                        .foregroundColor(.secondary)
                case .loading:
                    ProgressView().padding(.vertical, 8)
                case .result(let text):
                    Text(text).font(.body)
                        .lineSpacing(3)
                case .error(let msg):
                    Text("Error: \(msg)").foregroundColor(.red)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 12)
            .fill(Color(.secondarySystemBackground)))
        .overlay(RoundedRectangle(cornerRadius: 12)
            .stroke(.black.opacity(0.05)))
    }
}

#Preview {
    InsightsView(
        viewModel: .init(
            character: .init(
                id: "1",
                name: "Sam",
                status: "Dead",
                species: "rabbit",
                type: "",
                gender: "male",
                originName: "Mars",
                locationName: "Earth",
                imageURL: nil,
                episodes: [],
                createdAtISO: "2017-11-10T12:00:00Z"
            ),
            insights: DefaultInsightsService(
                llm: MockLLMClient()
            )
        )
    )
}
