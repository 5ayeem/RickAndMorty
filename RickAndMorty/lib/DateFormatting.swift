//
//  DateFormatting.swift
//  RickAndMorty
//
//  Created by Sayeem Hussain on 22/09/2025.
//

import Foundation

enum DateFormatting {
    static let isoFractional: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()
    
    static let monthDayYearUS: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale.current
        f.dateStyle = .long
        f.timeStyle = .none
        return f
    }()

    static func longUS(fromISO s: String) -> String? {
        let date = isoFractional.date(from: s)
        return date.map { monthDayYearUS.string(from: $0) }
    }
}
