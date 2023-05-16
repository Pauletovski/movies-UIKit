//
//  MainCoordinator.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 31/03/23.
//

import UIKit
import Combine
import Moya
import SwiftUI

protocol MoviesCoordinator {
    func presentMovieDetails(movie: MovieViewData) -> Void
    func start() -> Void
}

class Coordinator: MoviesCoordinator {
    var navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    let service: NetworkManager = NetworkManager()
    let tabBarController = UITabBarController()
    
    var cancelSet = Set<AnyCancellable>()
    
    lazy var homeViewModel = HomeViewModel(networkProvider: service, coordinator: self)
    lazy var homeViewController = HomeViewController(viewModel: homeViewModel)

    lazy var favoriteViewModel = FavoriteViewModel(networkProvider: service, homeViewModel: homeViewModel)
    lazy var favoriteViewController = FavoriteViewController(viewModel: favoriteViewModel)
    
    func start() {
        let firstTabBarItem = UITabBarItem(title: "Movie", image: UIImage(systemName: "popcorn"), tag: 0)
        let secondTabBarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "heart"), tag: 1)
        homeViewController.tabBarItem = firstTabBarItem
        favoriteViewController.tabBarItem = secondTabBarItem

        tabBarController.tabBar.backgroundColor = .primaryYellow
        tabBarController.viewControllers = [homeViewController, favoriteViewController]
        navigationController.setViewControllers([tabBarController], animated: false)
    }
    
    func presentMovieDetails(movie: MovieViewData) {
        let viewController = MovieDetailsViewController()
        viewController.contentView.configure(with: movie)
        
        viewController.contentView.onDismissTapped = {
            self.navigationController.dismiss(animated: true)
        }
    
        navigationController.present(viewController, animated: true)
    }
}
