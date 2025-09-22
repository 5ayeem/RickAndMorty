//
//  StatusPill.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 22/09/2025.
//

import SwiftUI

struct StatusPill: View {
    
    let status: String
    
    var color: Color {
        switch status.lowercased() {
        case "alive": return .green
        case "dead": return .red
        default: return .gray
        }
    }
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(status)
        }
        .font(.caption)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(color.opacity(0.15))
        )
    }
}
