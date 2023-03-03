import UIKit

protocol DailyTableCellViewModelType {
    var dayIcon: Bindable<UIImage?> { get }
    var day: String { get }
    var tempMin: String { get }
    var tempMax: String { get }
}

struct DailyTableCellViewModel: DailyTableCellViewModelType {
    
    let dayIcon = Bindable<UIImage?>(nil)
    private(set) var day: String
    private(set) var tempMin: String
    private(set) var tempMax: String
    
    private let weatherIconService: WeatherIconService
    
    init(
        _ dayForecast: DayForecast,
        isCurrentDay: Bool,
        iconService: WeatherIconService
    ) {
        self.weatherIconService = iconService
        
        self.day = isCurrentDay
        ? "Today".localized
        : dayForecast.date.format("EEEE").capitalizeFirstLetter
        
        self.tempMin = "\(dayForecast.tempMin)".withTempSymbol
        self.tempMax = "\(dayForecast.tempMax)".withTempSymbol
        
        getIcon(from: dayForecast.iconID)
    }

    private func getIcon(from id: String) {
        weatherIconService.getIcon(for: id) { [weak dayIcon] icon, iconID in
            guard id == iconID else { return }
            dayIcon?.value = icon
        }
    }
}
