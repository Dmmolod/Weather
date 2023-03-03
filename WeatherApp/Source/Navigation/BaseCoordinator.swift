//
//  BaseCoordinator.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 07.12.2022.
//

import UIKit

class BaseCoordinator: NSObject, Coordinator {
    typealias NavigationBackClosure = (() -> ())
    
    var navigationController: UINavigationController? {
        didSet {
            navigationController?.delegate = self
        }
    }
    var childCoordinators: [Coordinator] = []
    var rootViewController: UIViewController?
    
    var closures: [String: NavigationBackClosure] = [:]
    
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
    
    deinit {
        self.rootViewController = nil
        self.navigationController = nil
        self.childCoordinators.removeAll()
        self.closures.removeAll()
    }
}

extension BaseCoordinator {
    
    func push(
        _ coordinator: BaseCoordinator,
        animated: Bool = true,
        onNavigateBack: NavigationBackClosure? = nil
    ) {
        guard let rootViewController = coordinator.navigationController ?? coordinator.rootViewController else {
            return
        }
        
        self.push(rootViewController, animated: animated, onNavigateBack: onNavigateBack)
    }
    
    func present(_ coordinator: BaseCoordinator, animated: Bool = true) {
        guard let moduleViewController = coordinator.navigationController ?? coordinator.rootViewController else {
            return
        }
        self.rootViewController?.present(moduleViewController, animated: true)
    }
    
    func push(
        _ module: UIViewController,
        animated: Bool = true,
        onNavigateBack: NavigationBackClosure? = nil
    ) {
        if let closure = onNavigateBack {
            closures.updateValue(closure, forKey: module.description)
        }
        
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
    
    func dismiss(
        animated: Bool = true,
        modalTransitionStyle: UIModalTransitionStyle = .coverVertical,
        completion: (() -> Void)? = nil) {
            let rootViewController = self.navigationController ?? self.rootViewController
            rootViewController?.modalTransitionStyle = modalTransitionStyle
            rootViewController?.dismiss(animated: true, completion: completion)
    }
    
    func dismiss(animated: Bool, completion: (() -> Void)?) {
        let rootViewController = self.navigationController ?? self.rootViewController
        rootViewController?.dismiss(animated: true, completion: completion)
    }
    
    private func executeClosure(_ viewController: UIViewController) {
        guard let closure = closures.removeValue(forKey: viewController.description) else { return }
        closure()
    }
}

extension BaseCoordinator: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        guard
            let previousController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(previousController)
        else { return }
        
        executeClosure(previousController)
    }
}
