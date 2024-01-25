//
//  AddFiltersViewModel.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 18/05/23.
//

import Foundation

class AddFiltersViewModel {
    let networkProvider: Networkable
    
    var genresList: [Genre] = []
    
    init(networkProvider: Networkable){
        self.networkProvider = networkProvider
        
        getGenreList()
    }
    
    func getGenreList() {
        Task { @MainActor in
            let result = await self.networkProvider.getGenreList()
            switch result {
            case .success(let genres):
                self.genresList = genres
            case .failure(let error):
                print(error)
            }
        }
    }
}

