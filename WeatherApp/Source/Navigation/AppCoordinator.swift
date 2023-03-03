//
//  AppCoordinator.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 07.12.2022.
//

import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var rootViewController: UIViewController?
    var navigationController: UINavigationController?
    
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let viewController = LoadScreenFactory.makeLoadScreen(coordinator: self)
        
        rootViewController = viewController
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}

extension AppCoordinator: LoadScreenCoordinatorLogic {
    
    func didFinishFetchForecast(_ forecast: Forecast?) {
        let favoritesCoordinator = FavoritesScreenCoordinator(
            currentForecast: forecast,
            favoritesService: FavoritesService()
        )
        
        favoritesCoordinator.start()
        
        childCoordinators = [favoritesCoordinator]
        
        let newRootViewController = favoritesCoordinator.navigationController
        
        guard let fromView = rootViewController?.view else { return }
        fromView.frame = UIScreen.main.bounds
        
        self.navigationController = favoritesCoordinator.navigationController
        self.rootViewController = favoritesCoordinator.rootViewController
        
        self.window.rootViewController = newRootViewController
        self.window.addSubview(fromView)
        
        let animation = { fromView.alpha = 0 }
        let completion = { (success: Bool) -> () in fromView.removeFromSuperview() }
        
        UIView.animate(withDuration: 0.3, animations: animation, completion: completion)
    }
}
