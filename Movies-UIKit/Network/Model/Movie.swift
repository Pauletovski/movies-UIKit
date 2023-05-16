//
//  Movie.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 31/03/23.
//

import Foundation

struct Movie: Decodable {
    let title: String
    let id: Int
    let poster_path: String
    let overview: String
    let release_date: String
    let genre_ids: [Int]
}

struct MovieResults: Decodable {
    let results: [Movie]
    let page: Int?
}
