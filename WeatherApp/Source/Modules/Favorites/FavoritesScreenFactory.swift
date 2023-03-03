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
        favoritesService: FavoritesServiceProtocol,
        currentLocationForecast: Forecast? = nil
    ) -> UIViewController {
        let viewModel = FavoritesViewModel(
            currentLocationForecast: currentLocationForecast,
            favoritesService: favoritesService,
            iconService: WeatherIconService(),
            oneCallApiClient: OneCallApiClient()
        )
        
        let viewController = FavoritesController(
            viewModel: viewModel,
            coordinator: coordinator
        )
        
        return viewController
    }
}
