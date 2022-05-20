import Foundation
import UIKit

class DailyTableCellViewModel: DailyTableCellViewModelType {
    
    let dayIcon = Bindable<UIImage?>(nil)
    let day = Bindable<String>("")
    let temp_min = Bindable<String>("")
    let temp_max = Bindable<String>("")
    
    private var dayForecast: DayForecast
    private let weatherIconManager = WeatherIconManager()
    
    init(_ dayForecast: DayForecast, isCurrentDay: Bool) {
        self.dayForecast = dayForecast
        
        getIcon(from: dayForecast.iconID)
        setupValues(isCurrentDay)
    }

    private func getIcon(from id: String) {
        weatherIconManager.getIcon(for: id) { [weak self] icon, iconID in
            guard id == iconID,
                  let icon = icon else { return }
            self?.dayIcon.value = icon
        }
    }
    
    private func setupValues(_ isCurrentDay: Bool) {
        day.value = isCurrentDay ? "Today".localized : dayForecast.date.format("EEEE").capitalizeFirstLetter
        temp_min.value = String(dayForecast.temp_min).withTempSymbol
        temp_max.value = String(dayForecast.temp_max).withTempSymbol
    }
}
