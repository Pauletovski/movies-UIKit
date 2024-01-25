//
//  Genre.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 31/03/23.
//

struct Genres: Codable {
    let genres: [Genre]
}

struct Genre: Codable, Identifiable {
    let id: Int
    let name: String
}
