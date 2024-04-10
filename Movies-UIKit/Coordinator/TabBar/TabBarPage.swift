//
//  TabBarPage.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 28/01/24.
//

import UIKit

enum TabBarPage: Int, CaseIterable {
    case movies = 0
    case favorite = 1
    
    var title: String {
        switch self {
        case .movies:
            "Movies"
        case .favorite:
            "Favorites"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .movies:
            return UIImage(systemName: "popcorn")
        case .favorite:
            return UIImage(systemName: "heart")
        }
    }

    var selectedImage: UIImage? {
        switch self {
        case .movies:
            return UIImage(systemName: "popcorn.fill")
        case .favorite:
            return UIImage(systemName: "heart.fill")
        }
    }
    
    var tabBarItem: UITabBarItem {
        UITabBarItem(title: self.title, image: self.image, selectedImage: self.selectedImage)
    }
}
