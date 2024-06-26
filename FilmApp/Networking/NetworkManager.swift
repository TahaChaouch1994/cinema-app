//
//  NetworkManager.swift
//  FilmApp
//
//  Created by Taha Chaouch on 26/6/2024.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    let baseURL = "https://api.themoviedb.org/3"
    let apiKey = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5ZjVjYjRhOTE5OTUzNjRkOGIzZDQ2ZmM1ODhiNWM2NCIsIm5iZiI6MTcxOTQxMjQwNC43NTA3MTIsInN1YiI6IjY2N2MyNGVkMTQyYjA5ODZhOWU4M2Y2OCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.N0Vxv_rYja6oToIAEKYcXnilyer86FuH4A6_sBM7Aik"

    func fetchFilms(page: Int, completion: @escaping (Result<[Film], Error>) -> Void) {
        let urlString = "\(baseURL)/discover/movie?include_adult=false&include_video=false&language=en-US&page=\(page)&sort_by=popularity.desc"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let films = try JSONDecoder.customDecoder.decode(FilmResponse.self, from: data).results
                completion(.success(films))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }
        task.resume()
    }

    func fetchFilmDetail(filmID: Int, completion: @escaping (Result<FilmDetail, Error>) -> Void) {
        let urlString = "\(baseURL)/movie/\(filmID)?language=en-US"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let filmDetail = try JSONDecoder.customDecoder.decode(FilmDetail.self, from: data)
                completion(.success(filmDetail))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }
        task.resume()
    }
}
