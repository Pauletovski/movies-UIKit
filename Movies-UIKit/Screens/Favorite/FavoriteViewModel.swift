//
//  FavoriteViewModel.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 16/05/23.
//

import Foundation
import Combine

protocol FavoriteViewModelDelegate: AnyObject {
    func didGetMovies()
}

class FavoriteViewModel: NSObject {
    let networkProvider: Networkable
    weak var coordinator: AppCoordinating?
    weak var delegate: FavoriteViewModelDelegate?
    
    var moviesResult: [MovieViewData] = [] {
        didSet {
            self.delegate?.didGetMovies()
        }
    }
    var searchText: String = ""
    
    init(networkProvider: Networkable){
        self.networkProvider = networkProvider
        super.init()
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
        for (i, movie) in moviesResult.enumerated() {
            if let index = MovieDB.shared.favoritedIds.firstIndex(of: movie.id) {
                moviesResult[i].isFavorite = true
            } else {
                moviesResult[i].isFavorite = false
            }
        }
        
        self.moviesResult = self.moviesResult.filter({ $0.isFavorite ?? true })
    }
}
