//
//  NetworkError.swift
//  FilmApp
//
//  Created by Taha Chaouch on 26/6/2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case unknownError
}
