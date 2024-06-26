//
//  DateFormatter+Extension.swift
//  FilmApp
//
//  Created by Taha Chaouch on 26/6/2024.
//

import Foundation



extension DateFormatter {
    static var customFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}
