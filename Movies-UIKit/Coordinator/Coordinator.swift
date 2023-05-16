//
//  Coordinator.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 14/01/24.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var type: CoordinatorType { get set }
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    
    func start()
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

enum CoordinatorType {
    case details, movies, favorite
}

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}
