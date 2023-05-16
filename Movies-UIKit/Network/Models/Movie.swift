//
//  Movie.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 31/03/23.
//

struct Movie: Decodable {
    let title: String
    let id: Int
    let posterPath: String
    let overview: String
    let releaseDate: String
    let genreIds: [Int]
    
    enum CodingKeys: String, CodingKey {
        case title
        case id
        case posterPath = "poster_path"
        case overview
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
    }
}

struct Movies: Decodable {
    let results: [Movie]
    let page: Int?
}
