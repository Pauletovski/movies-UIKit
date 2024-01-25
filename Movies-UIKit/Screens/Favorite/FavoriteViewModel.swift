//
//  FavoriteViewModel.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 16/05/23.
//

import Foundation
import Combine

protocol FavoriteViewModelDelegate {
    func onReloadData()
}

class FavoriteViewModel {
    let networkProvider: Networkable
    weak var coordinator: AppCoordinating?
    
    var moviesFavorite: [MovieViewData] = []
    var filteredMovies: [MovieViewData] = []
    var genreFilteredMovies: [MovieViewData] = []
    var searchText: String = ""
    
    init(networkProvider: Networkable){
        self.networkProvider = networkProvider
    }
}
