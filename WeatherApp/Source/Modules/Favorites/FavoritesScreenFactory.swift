//
//  FavoritesScreenFactory.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 25.01.2023.
//

import UIKit

struct FavoritesScreenFactory {
    static func makeFavoriteScreen(
        coordinator: FavoritesScreenCoordinatorLogic,
        favoritesManager: FavoritesManagerProtocol,
        currentLocationForecast: Forecast? = nil
    ) -> UIViewController {
        let viewModel = FavoritesViewModel(
            currentLocationForecast: currentLocationForecast,
            favoritesManager: favoritesManager,
            weatherIconManager: WeatherIconManager(),
            oneCallApiClient: OneCallApiClient()
        )
        
        let viewController = FavoritesController(
            viewModel: viewModel,
            coordinator: coordinator
        )
        
        return viewController
    }
}
