//
//  JSONDecoder+Extension.swift
//  FilmApp
//
//  Created by Taha Chaouch on 26/6/2024.
//

import Foundation


extension JSONDecoder {
    static var customDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

