//
//  HomeViewModel.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 31/03/23.
//

import Foundation

protocol MoviesViewModelDelegate: AnyObject {
    func didGetMovies(movies: [MovieViewData])
}

class MoviesViewModel {
    private let networkProvider: Networkable
    weak var coordinator: AppCoordinating?
    weak var delegate: MoviesViewModelDelegate?
    
    var moviesResult: [MovieViewData] = []
    var filteredMovies: [MovieViewData] = []
    var genreFilteredMovies: [MovieViewData] = []
    var searchText: String = ""
    
    init(networkProvider: Networkable) {
        self.networkProvider = networkProvider
        self.getMovies(page: 1)
    }
    
    func getMovies(page: Int) {
        Task { @MainActor in
            let result = await self.networkProvider.getMovies(page: page)
            switch result {
            case .success(let movies):
                self.moviesResult = movies.results.map { MovieViewData(movie: $0) }
                self.delegate?.didGetMovies(movies: self.moviesResult)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func presentMovieDetails(movie: MovieViewData) {
        self.coordinator?.presentMovieDetails(movie: movie)
    }
}
