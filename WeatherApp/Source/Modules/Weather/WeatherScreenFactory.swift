//
//  WeatherScreenFactory.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 25.01.2023.
//

import UIKit

struct WeatherScreenFactory {
    static func makeWeatherScreen(
        with forecastLoadModel: ForecastLoadModel,
        coordinator: WeatherScreenCoordinatorLogic,
        favoritesManager: FavoritesManagerProtocol,
        isPresentationStyle: Bool
    ) -> UIViewController {
        
        let viewModel = WeatherViewModelImpl(
            loadModel: forecastLoadModel,
            oneCallApiClient: OneCallApiClient(),
            favoritesManager: favoritesManager,
            weatherIconManager: WeatherIconManager(),
            isPresentationStyle: isPresentationStyle
        )
        
        let viewController = WeatherViewController(
            coordinator: coordinator,
            viewModel: viewModel
        )
        
        return viewController
    }
}
