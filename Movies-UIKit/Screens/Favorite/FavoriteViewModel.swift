//
//  FavoriteViewModel.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 16/05/23.
//

import Foundation

protocol FavoriteViewModelDelegate: AnyObject {
    func reloadData()
    func didSelectedGenre(_ genre: Genre)
}

protocol FavoriteViewModelType: AnyObject {
    var networkProvider: Networkable { get set }
    var delegate: FavoriteViewModelDelegate? { get set }
    var moviesResult: [MovieViewData] { get set }
    
    func getFavoriteMovies(page: Int)
    func handleFavoriteTapped(with id: Int)
    func checkFavorite()
    func searchFilter(using searchText: String)
    func genreFilter()
    func removeGenreFilter()
    
    func presentMovieDetails(movie: MovieViewData)
    func presentAddFilter()
}

final class FavoriteViewModel: NSObject, FavoriteViewModelType {
    weak var coordinator: AppCoordinating?
    weak var delegate: FavoriteViewModelDelegate?
    
    private var allFavoritedMovies: [MovieViewData] = []
    
    var networkProvider: Networkable
    var moviesResult: [MovieViewData] = []
    
    init(networkProvider: Networkable){
        self.networkProvider = networkProvider
        super.init()
    }
    
    func getFavoriteMovies(page: Int) {
        Task { @MainActor in
            let result = await self.networkProvider.getMovies(page: page)
            switch result {
            case .success(let movies):
                self.moviesResult = movies.results.map { MovieViewData(movie: $0) }
                self.checkFavorite()
                self.genreFilter()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func presentMovieDetails(movie: MovieViewData) {
        self.coordinator?.presentMovieDetails(movie: movie)
    }
    
    func presentAddFilter() {
        self.coordinator?.presentAddFilter() { [weak self] in
            self?.genreFilter()
        }
    }
 
    func handleFavoriteTapped(with id: Int) {
        let index = moviesResult.firstIndex(where: { $0.id == id })
        
        if let index { moviesResult[index].isFavorite = false }
        
        self.checkFavorite()
    }
    
    func checkFavorite() {
        for (i, movie) in moviesResult.enumerated() {
            if MovieDB.shared.favoritedIds.contains(movie.id) {
                moviesResult[i].isFavorite = true
            } else {
                moviesResult[i].isFavorite = false
            }
        }
        
        self.moviesResult = self.moviesResult.filter({ $0.isFavorite ?? true })
        self.allFavoritedMovies = self.moviesResult
        self.delegate?.reloadData()
    }
    
    func searchFilter(using searchText: String) {
        self.moviesResult = allFavoritedMovies.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        self.delegate?.reloadData()
    }
    
    func genreFilter() {
        guard let genre = MovieDB.shared.genreSelected else { return }
        
        self.moviesResult = allFavoritedMovies.filter { $0.genreId.contains(genre.id) }
        self.delegate?.didSelectedGenre(genre)
        self.delegate?.reloadData()
    }
    
    func removeGenreFilter() {
        guard MovieDB.shared.genreSelected != nil else { return }
        
        MovieDB.shared.genreSelected = nil
        getFavoriteMovies(page: 1)
    }
}
