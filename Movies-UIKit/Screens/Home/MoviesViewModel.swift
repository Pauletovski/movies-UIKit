//
//  HomeViewModel.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 31/03/23.
//

import Foundation

protocol MoviesViewModelDelegate: AnyObject {
    func didGetMovies()
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
    }
    
    func getMovies(page: Int) {
        Task { @MainActor in
            let result = await self.networkProvider.getMovies(page: page)
            switch result {
            case .success(let movies):
                self.moviesResult = movies.results.map { MovieViewData(movie: $0) }
                self.checkFavorite()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func presentMovieDetails(movie: MovieViewData) {
        self.coordinator?.presentMovieDetails(movie: movie)
    }
    
    func checkFavorite(with id: Int) {
        let index = moviesResult.firstIndex(where: { $0.id == id })
        
        if let index { moviesResult[index].isFavorite = false }
        
        self.checkFavorite()
    }
    
    func checkFavorite() {
        resetFavorite()
        
        for (i, movie) in moviesResult.enumerated() {
            if let index = MovieDB.shared.favoritedIds.firstIndex(of: movie.id) {
                moviesResult[i].isFavorite = true
            } else {
                moviesResult[i].isFavorite = false
            }
        }
        
        self.delegate?.didGetMovies()
    }
    
    private func resetFavorite() {
        for i in 0..<moviesResult.count {
            moviesResult[i].isFavorite = false
        }
    }
}
