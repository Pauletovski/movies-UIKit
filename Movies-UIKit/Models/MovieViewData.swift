//
//  MovieViewData.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 16/05/23.
//

import Foundation

struct MovieViewData: Hashable, Identifiable {
    let id: Int
    let title: String
    let image: String
    let description: String
    let releaseDate: String
    let genreId: [Int]
    var isFavorite: Bool?
    
    init(movie: Movie) {
        self.title = movie.title
        self.image = movie.posterPath
        self.description = movie.overview
        self.releaseDate = movie.releaseDate
        self.id = movie.id
        self.genreId = movie.genreIds
        self.isFavorite = getIsFavorite()
    }
    
    init(movieDetails: MovieDetails) {
        self.title = movieDetails.title ?? ""
        self.image = movieDetails.posterPath ?? ""
        self.description = movieDetails.overview ?? ""
        self.releaseDate = movieDetails.releaseDate ?? ""
        self.id = movieDetails.id ?? 0
        self.genreId = movieDetails.genreIds ?? []
        self.isFavorite = getIsFavorite()
    }
    
    func getIsFavorite() -> Bool {
        guard !MovieDB.shared.favoritedIds.isEmpty else { return false }
        
        return MovieDB.shared.favoritedIds.contains(self.id)
    }
}
