//
//  AddFiltersViewModel.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 18/05/23.
//

import Foundation

protocol AddFiltersViewModelDelegate: AnyObject {
    func reloadData()
}

final class AddFiltersViewModel: NSObject {
    weak var coordinator: AppCoordinating?
    weak var delegate: AddFiltersViewModelDelegate?
    
    let networkProvider: Networkable
    var genresList: [Genre] = []
    
    init(networkProvider: Networkable) {
        self.networkProvider = networkProvider
        super.init()
        
        self.getGenreList()
    }
    
    func getGenreList() {
        Task { @MainActor in
            let result = await self.networkProvider.getGenreList()
            switch result {
            case .success(let genres):
                self.genresList = genres.genres
                self.delegate?.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func selectedGenre(_ genre: Genre) {
        MovieDB.shared.genreSelected = genre
    }
}

