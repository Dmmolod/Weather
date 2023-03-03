//
//  FavoritesScreenCoordinator.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 25.01.2023.
//
import UIKit

protocol FavoritesScreenCoordinatorLogic {
    func didTapfavoriteForecast(_ forecast: Forecast)
    func didTapSearchCity(_ cityInfo: CityInfo)
}

final class FavoritesScreenCoordinator: BaseCoordinator {
    
    private enum ShowWeatherOperationType {
        case present
        case push
    }
    
    private let currentForecast: Forecast?
    private let favoritesManager: FavoritesManagerProtocol
    
    init(
        currentForecast: Forecast? = nil,
        favoritesManager: FavoritesManagerProtocol
    ) {
        self.currentForecast = currentForecast
        self.favoritesManager = favoritesManager
    }
    
    override func start() {
        let viewController = FavoritesScreenFactory.makeFavoriteScreen(
            coordinator: self,
            favoritesManager: favoritesManager,
            currentLocationForecast: currentForecast
        )
        
        rootViewController = viewController
        navigationController = UINavigationController(rootViewController: viewController)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        pushWeatherControllerIfNeedIt()
    }
    
    private func pushWeatherControllerIfNeedIt() {
        guard let currentForecast else { return }
        showWeatherController(
            with: .forecast(currentForecast),
            operation: .push,
            animated: false
        )
    }
    
    private func showWeatherController(
        with loadModl: ForecastLoadModel,
        operation: ShowWeatherOperationType,
        animated: Bool = true
    ) {
        let coordinator = WeatherScreenCoordinator(
            source: self,
            loadModel: loadModl,
            favoritesManager: favoritesManager,
            isPresentationStyle: operation == .present
        )
        coordinator.start()
        
        add(coordinator)
        
        switch operation {
        case .present: present(coordinator, animated: animated)
        case .push:
            push(
                coordinator,
                animated: animated,
                onNavigateBack: { [weak self, weak coordinator] in
                    guard let coordinator else { return }
                    self?.remove(coordinator)
                }
            )
        }
    }
}

extension FavoritesScreenCoordinator: FavoritesScreenCoordinatorLogic {
    
    func didTapfavoriteForecast(_ forecast: Forecast) {
        showWeatherController(
            with: .forecast(forecast),
            operation: .push
        )
    }
    
    func didTapSearchCity(_ cityInfo: CityInfo) {
        showWeatherController(
            with: .cityInfo(cityInfo),
            operation: .present
        )
    }
    
}

extension FavoritesScreenCoordinator {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ZoomTransitioningDelegate(transitionOperation: operation)
    }
}
