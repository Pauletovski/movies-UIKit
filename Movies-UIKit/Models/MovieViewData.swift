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
    var isFavorite: Bool
    
    init(movie: Movie) {
        self.title = movie.title
        self.image = movie.posterPath
        self.description = movie.overview
        self.releaseDate = movie.releaseDate
        self.id = movie.id
        self.genreId = movie.genreIds
        self.isFavorite = false
    }
}
