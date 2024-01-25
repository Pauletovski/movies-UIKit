//
//  MovieDetailsViewModel.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 16/01/24.
//

import Foundation

protocol MovieDetailsViewModelDelegate: AnyObject {
    func didReceiveMovieDetails(movie: MovieViewData)
}

class MovieDetailsViewModel: NSObject {
    weak var delegate: MovieDetailsViewModelDelegate?
    
    var networkProvider: Networkable
    var movie: MovieViewData
    
    init(networkProvider: Networkable,
         movie: MovieViewData) {
        self.networkProvider = networkProvider
        self.movie = movie
        super.init()
        
        self.getMovieDetails()
    }

    private func getMovieDetails() {
        Task { @MainActor in
            let result = await self.networkProvider.getMovieDetails(id: self.movie.id)
            switch result {
            case .success(let movie):
                self.delegate?.didReceiveMovieDetails(movie: MovieViewData(movieDetails: movie))
            case .failure(let error):
                print(error)
            }
        }
    }
}

