//
//  MovieDB.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 25/01/24.
//

import Foundation

final class MovieDB {
    static let shared: MovieDB = MovieDB()
    
    private let userDefaults = UserDefaults.standard
    private let favoritedIdsKey = "favoritedIds"
    
    var favoritedIds: [Int] {
        get {
            if let storedIds = userDefaults.array(forKey: favoritedIdsKey) as? [Int] {
                return storedIds
            }
            return []
        }
        set {
            userDefaults.set(newValue, forKey: favoritedIdsKey)
        }
    }
    
    private init() {}
}

