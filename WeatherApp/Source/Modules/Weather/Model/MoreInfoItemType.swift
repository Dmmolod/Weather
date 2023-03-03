//
//  MoreInfoItemType.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 26.01.2023.
//

import UIKit

enum MoreInfoItemType: CaseIterable {
    
    case humidity
    case windSpeed
    case feelsLike
    case pressure
    
    var info: (
        icon: UIImage?,
        titleText: String
    ) {
        switch self {
        case .humidity: return (
            icon: UIImage(systemName: "humidity")?.withTintColor(.white, renderingMode: .alwaysOriginal),
            titleText: "humidity".localized.uppercased()
        )
        case .windSpeed: return (
            icon: UIImage(systemName: "wind")?.withTintColor(.white, renderingMode: .alwaysOriginal),
            titleText: "wind".localized.uppercased()
        )
        case .feelsLike: return (
            icon: UIImage(systemName: "thermometer")?.withTintColor(.white, renderingMode: .alwaysOriginal),
            titleText: "feels like".localized.uppercased()
        )
        case .pressure: return (
            icon: UIImage(named: "pressure")?.withTintColor(.white, renderingMode: .alwaysOriginal),
            titleText: "pressure".localized.uppercased()
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
