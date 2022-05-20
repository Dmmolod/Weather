import Foundation

class HourlyTableCellViewModel: HourlyTableCellViewModelType {
    
    private let hourlyForecast: [HourForecast]
    
    init(hourlyForecast: [HourForecast]) {
        self.hourlyForecast = hourlyForecast
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int? {
        return hourlyForecast.count
    }
    
    func hourCollectionCellViewModelType(for indexPath: IndexPath) ->
        HourCollectionCellViewModelType? {
            guard indexPath.item < hourlyForecast.count else { return nil }
            
        if indexPath.item == 0 {
            return HourCollectionCellViewModel(hourlyForecast[indexPath.item], isCurrentHour: true)
        }
        return HourCollectionCellViewModel(hourlyForecast[indexPath.item])
    }
}
