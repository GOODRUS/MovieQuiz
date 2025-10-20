//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Дмитрий Шиляев on 15.10.2025.
//

import Foundation

enum MoviesLoadingError: Error, LocalizedError {
    case apiError(message: String)
    
    var errorDescription: String? {
        switch self {
        case .apiError(let message):
            return message
        }
    }
}

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    // MARK: - NetworkClient
    private let networkClient: NetworkRouting
     
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else { //k_zcuw1ytf/k_g7i9nnmv
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    if let errorMsg = mostPopularMovies.errorMessage, !errorMsg.isEmpty {
                        handler(.failure(MoviesLoadingError.apiError(message: errorMsg)))
                    } else {
                        handler(.success(mostPopularMovies))
                    }
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
