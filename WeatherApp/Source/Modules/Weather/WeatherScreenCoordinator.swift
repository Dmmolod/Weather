//
//  WeatherScreenCoordinator.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 25.01.2023.
//

import UIKit

protocol WeatherScreenCoordinatorLogic: AnyObject {
    func didTapCancel()
    func didTapShowFavorites()
    func didTapAddToFavorites()
}

final class WeatherScreenCoordinator: BaseCoordinator {
    
    private weak var source: BaseCoordinator?
    private let loadModel: ForecastLoadModel
    private let favoritesService: FavoritesServiceProtocol
    private let isPresentationStyle: Bool
    
    init(
        source: BaseCoordinator,
        loadModel: ForecastLoadModel,
        favoritesService: FavoritesServiceProtocol,
        isPresentationStyle: Bool
    ) {
        self.favoritesService = favoritesService
        self.source = source
        self.loadModel = loadModel
        self.isPresentationStyle = isPresentationStyle
    }
    
    override func start() {
        let viewController = WeatherScreenFactory.makeWeatherScreen(
            with: loadModel,
            coordinator: self,
            favoritesService: favoritesService,
            isPresentationStyle: isPresentationStyle
        )
        
        rootViewController = viewController
    }
}

extension WeatherScreenCoordinator: WeatherScreenCoordinatorLogic {
    func didTapCancel() {
        dismiss(animated: true)
    }
    
    func didTapShowFavorites() {
        source?.pop(animated: true)
    }
    
    func didTapAddToFavorites() {
        dismiss(animated: true)
    }
}
