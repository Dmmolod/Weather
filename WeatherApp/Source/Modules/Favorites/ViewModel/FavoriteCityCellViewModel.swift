import Foundation
import UIKit

struct FavoriteCellViewModel {
    
    let headerTitle: String
    let subtitle: String
    let descriptionTitle: String
    let currentTemperatureTitle: String
    let infoTemperatureTitle: String
    let gradientColors: [CGColor]
    let icon = Bindable<UIImage?>(nil)
    
    private let iconID: String
    private let isCurrentLocationCity: Bool
    private let iconService: WeatherIconService
    
    init(
        headerTitle: String,
        subtitle: String,
        descriptionTitle: String,
        currentTemperatureTitle: String,
        infoTemperatureTitle: String,
        gradientColors: [CGColor],
        iconID: String,
        isCurrentLocationCity: Bool,
        iconService: WeatherIconService
    ) {
        self.headerTitle = headerTitle
        self.subtitle = subtitle
        self.descriptionTitle = descriptionTitle
        self.currentTemperatureTitle = currentTemperatureTitle
        self.infoTemperatureTitle = infoTemperatureTitle
        self.gradientColors = gradientColors
        self.iconID = iconID
        self.isCurrentLocationCity = isCurrentLocationCity
        self.iconService = iconService
        
        getImage()
    }
    
     private func getImage() {
         iconService.getIcon(for: iconID) { [weak icon] forecastIcon, iconID in
             guard self.iconID == iconID else { return }
             icon?.value = forecastIcon
         }
     }
}

extension FavoriteCellViewModel {
    static func make(
        _ forecast: Forecast,
        isCurrentLocationCity: Bool,
        iconService: WeatherIconService
    ) -> FavoriteCellViewModel {
        let headerTitle = isCurrentLocationCity ? "Current".localized : forecast.cityName
        let subtitle = isCurrentLocationCity ? forecast.cityName : forecast.current.date.format("HH:mm")
        let descriptionTitle = forecast.current.description.lowercased().capitalizeFirstLetter
        let currentTemperatureTitle = forecast.current.temp.description.withTempSymbol
        let infoTemperatureTitle = "\("min".localized.capitalized).: \(forecast.daily[0].tempMin.description.withTempSymbol), \("max".localized).: \(forecast.daily[0].tempMax.description.withTempSymbol)"
        
        let gradientColors: [CGColor]
        
        if let currentTime = Int(forecast.current.date.format("H")),
           let weatherState = VisualWeatherModel.WeatherState(rawValue: forecast.current.weatherState.lowercased())
        {
            gradientColors = VisualWeatherModel(
                dayTime: VisualWeatherModel.dayType(from: currentTime),
                weatherState: weatherState
            ).gradient()
        }
        else {
            gradientColors = VisualWeatherModel(
                dayTime: .day,
                weatherState: .clear
            ).gradient()
        }
        
        return FavoriteCellViewModel(
            headerTitle: headerTitle,
            subtitle: subtitle,
            descriptionTitle: descriptionTitle,
            currentTemperatureTitle: currentTemperatureTitle,
            infoTemperatureTitle: infoTemperatureTitle,
            gradientColors: gradientColors,
            iconID: forecast.current.iconID,
            isCurrentLocationCity: isCurrentLocationCity,
            iconService: iconService
        )
    }
}
