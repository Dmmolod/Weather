//
//  BaseCoordinator.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 07.12.2022.
//

import UIKit

class BaseCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var rootViewController: UIViewController?
    
    func start() {}
    
    func getChildCoordinator<CoordinatorType>() -> CoordinatorType? {
        self.childCoordinators.first(where: { $0 is CoordinatorType }) as? CoordinatorType
    }
    
    func remove(_ coordinator: BaseCoordinator) {
        self.childCoordinators.removeAll(where: { ($0 as? BaseCoordinator) == coordinator })
        print("\(Self.self): Removed a child coordinator of type - \(coordinator.self)")
    }
    
    func add(_ coordinator: BaseCoordinator) {
        if !self.childCoordinators.contains(where: { $0 as? BaseCoordinator == coordinator}) {
            self.childCoordinators.append(coordinator)
            print("\(Self.self): Added a child coordinator of type - \(coordinator.self)")
        }
    }
}

extension BaseCoordinator: RoutingLogic {
    
    func push(_ coordinator: BaseCoordinator, animated: Bool = true) {
        guard let rootViewController = coordinator.navigationController ?? coordinator.rootViewController else {
            return
        }
        self.push(rootViewController, animated: animated)
    }
    
    func present(_ coordinator: BaseCoordinator, animated: Bool = true) {
        guard let moduleViewController = coordinator.navigationController ?? coordinator.rootViewController else {
            return
        }
        self.rootViewController?.present(moduleViewController, animated: true)
    }
    
    func push(_ module: UIViewController, animated: Bool = true) {
        let parent = navigationController ?? rootViewController?.navigationController
        
        parent?.pushViewController(module, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func present(_ module: UIViewController, animated: Bool) {
        let parent = navigationController ?? rootViewController
        parent?.present(module, animated: animated)
    }
    
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        let rootViewController = self.navigationController ?? self.rootViewController
        rootViewController?.dismiss(animated: true, completion: completion)
    }
}
