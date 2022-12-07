//
//  AppCoordinatorV2.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 07.12.2022.
//

import UIKit

final class AppCoordinatorV2: Coordinator {
    var childCoordinators: [Coordinator] = []
    var rootViewController: UIViewController?
    var navigationController: UINavigationController?
    
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        
    }
}
