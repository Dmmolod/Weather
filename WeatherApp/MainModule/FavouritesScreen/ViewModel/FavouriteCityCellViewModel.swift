import Foundation
import UIKit

class FavouriteCityCellViewModel {
    
    private let networkManager: NetworkManagerProtocol
    
    let headerTitle = Bindable<String>("")
    let subTitle = Bindable<String>("")
    let descriptionTitle = Bindable<String>("")
    let currentTemperatureTitle = Bindable<String>("")
    let infoTemperatureTitle = Bindable<String>("")
    let icon = Bindable<UIImage?>(nil)
    let gradientType = Bindable<(dayTime: VisualWeatherModel.DayTime,
                                 weatherState: VisualWeatherModel.WeatherState)>((dayTime: .day,
                                                                                 weatherState: .clear))
    private var cellForecast: Forecast
    private let isCurrentLocationCity: Bool
    
    init(_ cellForecast: Forecast, _ isCurrentLocationCity: Bool, _ networkManager: NetworkManagerProtocol) {
        
        self.networkManager = networkManager
        self.cellForecast = cellForecast
        self.isCurrentLocationCity = isCurrentLocationCity
        
        setupMainValues()
        getImage()
        setupGradient()
    }
    
    private func setupMainValues() {
        headerTitle.value = isCurrentLocationCity ? "Current".localized : cellForecast.cityName
        subTitle.value = isCurrentLocationCity ? cellForecast.cityName : cellForecast.current.date.format("HH:mm")
        
        descriptionTitle.value = cellForecast.current.description.lowercased().capitalizeFirstLetter
        currentTemperatureTitle.value = cellForecast.current.temp.description.withTempSymbol
        infoTemperatureTitle.value = "\("min".localized.capitalized).: \(cellForecast.daily[0].temp_min.description.withTempSymbol), \("max".localized).: \(cellForecast.daily[0].temp_max.description.withTempSymbol)"
    }
    
     private func getImage() {
         let id = cellForecast.current.iconID
         WeatherIconManager().getIcon(for: id) { [weak self] icon, iconID in
             guard id == iconID else { return }
             self?.icon.value = icon
         }
     }
    
    private func setupGradient() {
        let currentForecast = cellForecast.current

        guard let currentTime = Int(currentForecast.date.format("H")),
              let weatherState = VisualWeatherModel.WeatherState(rawValue: currentForecast.weatherState.lowercased()) else { return }
        
        let dayTimeType = VisualWeatherModel.dayType(from: currentTime)
        
        gradientType.value = (dayTime: dayTimeType,
                              weatherState: weatherState)
    }
}
