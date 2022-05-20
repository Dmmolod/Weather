import Foundation
import UIKit

class HourCollectionCellViewModel: HourCollectionCellViewModelType {
    
    let time = Bindable<String>("")
    let icon = Bindable<UIImage?>(nil)
    let temperature = Bindable<String>("")

    private let hourForecast: HourForecast
    private let isCurrentHour: Bool
    private let weatherIconManager = WeatherIconManager()
    
    init(_ hourForecast: HourForecast, isCurrentHour: Bool = false) {
        self.hourForecast = hourForecast
        self.isCurrentHour = isCurrentHour
        
        getImage(from: hourForecast.iconID)
        setupValues()
    }
    
   private func getImage(from id: String) {
       weatherIconManager.getIcon(for: id) { [weak self] icon, iconID in
            guard id == iconID else { return }
            self?.icon.value = icon
        }
    }
    
    private func setupValues() {
        
        time.value = isCurrentHour ? "Now".localized : hourForecast.date.format("HH")
        temperature.value = String(hourForecast.temp).withTempSymbol
    }
    
}
