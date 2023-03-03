import UIKit

protocol HourCollectionCellViewModelType {
    var time: String { get }
    var temperature: String { get }
    var icon: Bindable<UIImage?> { get }
}

struct HourCollectionCellViewModel: HourCollectionCellViewModelType {

    let time: String
    let temperature: String
    let icon = Bindable<UIImage?>(nil)

    private let iconService = WeatherIconService()
    
    init(
        _ hourForecast: HourForecast,
        isCurrentHour: Bool = false,
        iconService: WeatherIconService
    ) {
        time = isCurrentHour ? "Now".localized : hourForecast.date.format("HH")
        temperature = String(hourForecast.temp).withTempSymbol
        
        getImage(from: hourForecast.iconID)
    }
    
    private func getImage(from id: String) {
        iconService.getIcon(for: id) { [weak icon] fetchIcon, iconID in
            guard id == iconID else { return }
            icon?.value = fetchIcon
        }
    }
}
