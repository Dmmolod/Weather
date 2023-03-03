//
//  MoreInfoCellViewModel.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 26.01.2023.
//

import UIKit

struct MoreInfoCellViewModel {
    var currentForecast: CurrentForescast
    var infoCells: [MoreInfoItemType]
}

enum MoreInfoItemType: CaseIterable {
    
    case humidity
    case windSpeed
    case feelsLike
    case pressure
    
    private var privateInfo: (
        imageName: String,
        titleText: String
    ) {
        switch self {
        case .humidity: return ("humidity", "humidity".localized)
        case .windSpeed: return ("wind", "wind".localized)
        case .feelsLike: return ("thermometer", "feels like".localized)
        case .pressure: return ("pressure", "pressure".localized)
        }
    }
    
    var info: (
        icon: UIImage?,
        titleText: String
    ) {
        switch self {
        case .pressure:
            return (
                icon: UIImage(named: privateInfo.imageName)?.withTintColor(.white, renderingMode: .alwaysOriginal),
                titleText: privateInfo.titleText
            )
        default: return (
            icon: UIImage(systemName: privateInfo.imageName)?.withTintColor(.white, renderingMode: .alwaysOriginal),
            titleText: privateInfo.titleText
        )
        }
    }
    
    func descriptionText(for currentForecast: CurrentForescast) -> String {
        switch self {
        case .humidity: return "\(currentForecast.humidity)%"
        case .windSpeed: return "\(currentForecast.windSpeed) \("m/s".localized)"
        case .feelsLike: return String(currentForecast.feelsLike).withTempSymbol
        case .pressure: return "\(Int(currentForecast.pressure * 0.75))\n\("mmHg".localized)"
        }
    }
}
