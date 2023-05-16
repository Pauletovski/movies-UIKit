//
//  MovieDB.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 25/01/24.
//

import Foundation

final class MovieDB {
    enum Constants {
        static let favoritedIdsKey = "favoritedIds"
        static let genreKey = "genre"
    }
    
    static let shared: MovieDB = MovieDB()

    private let userDefaults = UserDefaults.standard
    
    var favoritedIds: [Int] {
        get {
            if let storedIds = userDefaults.array(forKey: Constants.favoritedIdsKey) as? [Int] {
                return storedIds
            }
            return []
        }
        set {
            userDefaults.set(newValue, forKey: Constants.favoritedIdsKey)
        }
    }
    
    var genreSelected: Genre? {
        get {
            if let storedData = userDefaults.data(forKey: Constants.genreKey),
               let storedGenre = try? JSONDecoder().decode(Genre.self, from: storedData) {
                return storedGenre
            }
            return nil
        }
        set {
            if let encodedData = try? JSONEncoder().encode(newValue) {
                userDefaults.set(encodedData, forKey: Constants.genreKey)
            }
        }
    }
    
    private init() {}
}

