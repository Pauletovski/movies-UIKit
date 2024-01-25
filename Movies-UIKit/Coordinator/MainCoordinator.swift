//
//  MainCoordinator.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 31/03/23.
//

//import UIKit
//import Combine
//import Moya
//import SwiftUI
//
//protocol MoviesCoordinatorDelegate: AnyObject {
//    func presentMovieDetails(movie: MovieViewData) -> Void
//}
//
//protocol FavoriteMoviesCoordinator {
//    func presentAddFilter() -> Void
//}
//
//class Coordinator: FavoriteMoviesCoordinator {
//    private var navigationController: UINavigationController
//    private var homeViewModel: HomeViewModel?
//    private var favoriteViewModel: FavoriteViewModel?
//    
//    init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//        self.homeViewModel = HomeViewModel(networkProvider: service)
//        self.favoriteViewModel = FavoriteViewModel(networkProvider: service, homeViewModel: homeViewModel!, coordinator: self)
//        
//        self.homeViewModel?.delegate = self
//    }
//    
//    let service: NetworkManager = NetworkManager()
//    let tabBarController = UITabBarController()
//    
//    var cancelSet = Set<AnyCancellable>()
//    
//    var homeViewController: UIViewController?
//    var favoriteViewController: UIViewController?
//    
//    func start() {
//        guard let homeViewModel, let favoriteViewModel else { return }
//        self.homeViewController = HomeViewController(viewModel: homeViewModel)
//        self.favoriteViewController =  FavoriteViewController(viewModel: favoriteViewModel)
//        
//        let firstTabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "popcorn"), tag: 0)
//        let secondTabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), tag: 1)
//        homeViewController?.tabBarItem = firstTabBarItem
//        favoriteViewController?.tabBarItem = secondTabBarItem
//        
//        guard let homeViewController, let favoriteViewController else { return }
//
//        tabBarController.tabBar.backgroundColor = .primaryYellow
//        tabBarController.viewControllers = [homeViewController, favoriteViewController]
//        navigationController.setViewControllers([tabBarController], animated: false)
//    }
//    
//}
//
//extension Coordinator: MoviesCoordinatorDelegate {

//}
