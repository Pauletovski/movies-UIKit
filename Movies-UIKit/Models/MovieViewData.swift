//
//  MovieViewData.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 16/05/23.
//

import Foundation

struct MovieViewData: Hashable {
    let title: String
    let image: String
    let description: String
    let releaseDate: String
    let id: Int
    var isFavorite: Bool
}
