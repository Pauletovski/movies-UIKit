//
//  AddFiltersViewModel.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 18/05/23.
//

import Foundation
import Combine

class AddFiltersViewModel {
    let networkProvider: Networkable
    var favoriteViewModel: FavoriteViewModel
    
    var genresList: [Genre] = []
    
    let reloadData = PassthroughSubject<Void, Never>()
    
    
    var cancelSet = Set<AnyCancellable>()
    
    init(networkProvider: Networkable, favoriteViewModel: FavoriteViewModel){
        self.networkProvider = networkProvider
        self.favoriteViewModel = favoriteViewModel
        
        getGenreList()
        
    }
    
    func getGenreList() {
        networkProvider.getGenreList { [weak self] genres in
            self?.genresList = genres.map({ $0})
            self?.reloadData.send()
        }
    }
}

