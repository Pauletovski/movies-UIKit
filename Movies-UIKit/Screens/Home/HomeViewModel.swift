//
//  HomeViewModel.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 31/03/23.
//

import Foundation
import Combine

class HomeViewModel {
    let networkProvider: Networkable
    let coordinator: MoviesCoordinator
    
    var moviesResult: [MovieViewData] = []
    var moviesFavorite: [MovieViewData] = []
    var filteredMovies: [MovieViewData] = []
    var searchText: String = ""
    
    let reloadData = PassthroughSubject<Void, Never>()
    let onFavoriteChanged = PassthroughSubject<Int, Never>()
    let favoritedMovies = PassthroughSubject<[MovieViewData], Never>()
    let onPresentMovieDetails = PassthroughSubject<MovieViewData, Never>()
    
    var cancelSet = Set<AnyCancellable>()
    
    init(networkProvider: Networkable, coordinator: MoviesCoordinator) {
        self.networkProvider = networkProvider
        self.coordinator = coordinator
        
        self.getNewMovies(page: 1)
        
        onPresentMovieDetails
            .sink { [weak self] movie in
                guard let self else { return }
                
                self.coordinator.presentMovieDetails(movie: movie)
            }.store(in: &cancelSet)
        
        onFavoriteChanged
            .sink { [weak self] movieId in
                guard let self else { return }
                
                if let movieFavoriteIndex = self.moviesFavorite.firstIndex(where: { $0.id == movieId }) {
                    if self.moviesFavorite[movieFavoriteIndex].isFavorite {
                        self.moviesFavorite.remove(at: movieFavoriteIndex)
                    }
                }
                
                if let moviesResultIndex = self.moviesResult.firstIndex(where: { $0.id == movieId }) {
                    if self.moviesResult[moviesResultIndex].isFavorite {
                        self.moviesResult[moviesResultIndex].isFavorite = false
                    } else {
                        self.moviesResult[moviesResultIndex].isFavorite = true
                        self.moviesFavorite.append(self.moviesResult[moviesResultIndex])
                    }
                }
                
                if let moviesFilteredIndex = self.filteredMovies.firstIndex(where: { $0.id == movieId }) {
                    if self.filteredMovies[moviesFilteredIndex].isFavorite {
                        self.filteredMovies[moviesFilteredIndex].isFavorite = false
                    } else {
                        self.filteredMovies[moviesFilteredIndex].isFavorite = true
                        self.moviesFavorite.append(self.moviesResult[moviesFilteredIndex])
                    }
                }
                
                
                self.favoritedMovies.send(self.moviesFavorite)
                self.reloadData.send()
            }.store(in: &cancelSet)
        
        favoritedMovies
            .sink { [weak self] favoriteMovies in
                guard let self else { return }
                
                self.moviesFavorite = []
                self.moviesFavorite = favoriteMovies
                self.reloadData.send()
            }.store(in: &cancelSet)
    }
    
    func getNewMovies(page: Int) {
        self.networkProvider.getNewMovies(page: page) { movies in
            self.moviesResult = movies.map({ MovieViewData(title: $0.title,
                                                           image: $0.poster_path,
                                                           description: $0.overview,
                                                           releaseDate: $0.release_date,
                                                           id: $0.id,
                                                           isFavorite: false) })
            self.reloadData.send()
        }
    }
}
