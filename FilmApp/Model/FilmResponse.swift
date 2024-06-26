//
//  MovieResponse.swift
//  FilmApp
//
//  Created by Taha Chaouch on 26/6/2024.
//

import Foundation


struct FilmResponse: Codable {
    let page: Int
    let results: [Film]
    let totalPages: Int
    let totalResults: Int

    private enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
