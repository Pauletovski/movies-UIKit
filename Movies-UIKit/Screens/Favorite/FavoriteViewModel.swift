//
//  FavoriteViewModel.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 16/05/23.
//

import Foundation
import Combine

class FavoriteViewModel {
    let networkProvider: Networkable
    var homeViewModel: HomeViewModel
    var coordinator: FavoriteMoviesCoordinator
    
    var moviesFavorite: [MovieViewData] = []
    var filteredMovies: [MovieViewData] = []
    var genreFilteredMovies: [MovieViewData] = []
    var searchText: String = ""
    
    let reloadData = PassthroughSubject<Void, Never>()
    let onFavoriteChanged = PassthroughSubject<Int, Never>()
    let onGenreFilterSelected = PassthroughSubject<Genre, Never>()
    let onFiltersRemoved = PassthroughSubject<Void, Never>()
    
    var cancelSet = Set<AnyCancellable>()
    
    init(networkProvider: Networkable, homeViewModel: HomeViewModel, coordinator: FavoriteMoviesCoordinator){
        self.networkProvider = networkProvider
        self.homeViewModel = homeViewModel
        self.coordinator = coordinator
        
        onFiltersRemoved
            .sink { [weak self] _ in
                guard let self else { return }
                
                self.filteredMovies = []
                self.genreFilteredMovies = []
                
                
                self.reloadData.send()
            }.store(in: &cancelSet)
        
        onGenreFilterSelected
            .sink { [weak self] genre in
                guard let self else { return }
                
                self.filteredMovies = []
                
                self.moviesFavorite.map { movie in
                    movie.genreId.map { genreId in
                        if genreId == genre.id {
                            self.genreFilteredMovies = []
                            self.genreFilteredMovies.append(movie)
                        }
                    }
                }
                
                self.filteredMovies = self.genreFilteredMovies
                self.reloadData.send()
            }.store(in: &cancelSet)
        
        onFavoriteChanged
            .sink { [weak self] movieID in
                guard let self else { return }

                if let movieFavoriteIndex = self.moviesFavorite.firstIndex(where: { $0.id == movieID }) {
                    self.moviesFavorite.remove(at: movieFavoriteIndex)
                }
                
                if let movieFilteredIndex = self.filteredMovies.firstIndex(where: { $0.id == movieID }) {
                    self.filteredMovies.remove(at: movieFilteredIndex)
                }
                
                self.homeViewModel.onFavoriteChanged.send(movieID)
                self.homeViewModel.favoritedMovies.send(self.moviesFavorite)
                self.reloadData.send()
            }.store(in: &cancelSet)
        
        homeViewModel.favoritedMovies
            .sink { [weak self] favoriteMovies in
                guard let self else { return }
                
                self.moviesFavorite = []
                self.moviesFavorite = favoriteMovies
                self.reloadData.send()
            }.store(in: &cancelSet)
    }
}
