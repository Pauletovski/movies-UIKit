//
//  HomeViewModel.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 31/03/23.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func reloadData()
}

protocol HomeViewModelType: AnyObject {
    var networkProvider: Networkable { get set }
    var delegate: HomeViewModelDelegate? { get set }
    var coordinator: AppCoordinating? { get set }
    var moviesResult: [MovieViewData] { get set }
    
    func getMovies(page: Int)
    func handleFavoriteTapped(with id: Int)
    func checkFavorite()
    func searchFilter(using searchText: String)
    
    func presentMovieDetails(movie: MovieViewData)
}

final class HomeViewModel: NSObject, HomeViewModelType {
    weak var coordinator: AppCoordinating?
    weak var delegate: HomeViewModelDelegate?
    
    private var allMovies: [MovieViewData] = []
    
    var networkProvider: Networkable
    var moviesResult: [MovieViewData] = []
    
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
    
    func handleFavoriteTapped(with id: Int) {
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
        
        self.allMovies = self.moviesResult
        self.delegate?.reloadData()
    }
    
    private func resetFavorite() {
        for i in 0..<moviesResult.count {
            moviesResult[i].isFavorite = false
        }
    }
    
    func searchFilter(using searchText: String) {
        self.moviesResult = allMovies.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        self.delegate?.reloadData()
    }
}
