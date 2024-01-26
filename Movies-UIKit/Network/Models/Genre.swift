//
//  Genre.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 31/03/23.
//

struct Genres: Decodable {
    let genres: [Genre]
}

struct Genre: Decodable, Encodable, Identifiable {
    let id: Int
    let name: String
}
