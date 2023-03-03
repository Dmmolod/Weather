//
//  LoadScreenFactory.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 25.01.2023.
//

import UIKit
import CoreLocation

struct LoadScreenFactory {
    
    static func makeLoadScreen(coordinator: LoadScreenCoordinatorLogic) -> UIViewController {
        let viewModel = LoadScreenViewModel(
            oneCallApiClient: OneCallApiClient(),
            coordinator: coordinator,
            locationManager: CLLocationManager()
        )
        
        let viewController = LoadScreenController(viewModel: viewModel)
        
        return viewController
    }
}
