//
//  AppCoordinator.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 15/01/24.
//

import UIKit

protocol AppCoordinating: Coordinator {
    func presentMovieDetails(movie: MovieViewData)
    func presentAddFilter(onDismiss: @escaping () -> Void)
}

class AppCoordinator: AppCoordinating {
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .movies
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    private var tabBarController: UITabBarController
    
    let networkManager: NetworkManager = NetworkManager()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        tabBarController.viewControllers = TabBarPage.allCases.map { makeViewController(for: $0) }
        tabBarController.tabBar.backgroundColor = .primaryYellow
        tabBarController.tabBar.tintColor = .primaryGray
        navigationController.setViewControllers([tabBarController], animated: false)
    }
    
    func presentMovieDetails(movie: MovieViewData) {
        let viewModel = MovieDetailsViewModel(networkProvider: networkManager,
                                              movie: movie)
        let viewController = MovieDetailsViewController(viewModel: viewModel)
        
        viewController.modalPresentationStyle = .pageSheet
        
        viewController.contentView.onDismissTapped = {
            self.dismiss(true)
        }
        
        present(viewController, true)
    }
    
    func presentAddFilter(onDismiss: @escaping () -> Void) {
        let viewModel = AddFiltersViewModel(networkProvider: networkManager)
        viewModel.coordinator = self
        let viewController = AddFilterViewController(viewModel: viewModel)
        
        viewController.contentView.onDismissTapped = {
            onDismiss()
            self.dismiss(true)
        }
        
        present(viewController, true)
    }
}

extension AppCoordinator {
    private func makeViewController(for tabBarPage: TabBarPage) -> UIViewController {
        switch tabBarPage {
        case .movies:
            let viewModel = MoviesViewModel(networkProvider: networkManager)
            viewModel.coordinator = self
            let viewController = MoviesViewController(viewModel: viewModel)
            viewController.tabBarItem = tabBarPage.tabBarItem
            return viewController
        case .favorite:
            let viewModel = FavoriteViewModel(networkProvider: networkManager)
            viewModel.coordinator = self
            let viewController = FavoriteViewController(viewModel: viewModel)
            viewController.tabBarItem = tabBarPage.tabBarItem
            return viewController
        }
    }
}

// MARK: - METHODS

extension AppCoordinator {
    private func push(_ vc: UIViewController, _ animated: Bool = false) {
        self.navigationController.pushViewController(vc, animated: animated)
    }
    
    private func popVC(_ animated: Bool = false) {
        self.navigationController.popViewController(animated: animated)
    }
    
    private func dismiss(_ animated: Bool = false) {
        self.navigationController.dismiss(animated: animated)
    }
    
    private func present(_ vc: UIViewController, _ animated: Bool = false) {
        self.navigationController.present(vc, animated: animated)
    }
}

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
