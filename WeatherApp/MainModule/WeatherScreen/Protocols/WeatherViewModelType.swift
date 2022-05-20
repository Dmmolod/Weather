import Foundation

protocol WeatherViewModelType: AnyObject {
    
    var transitionCellIndexPath: IndexPath { get }
    var forecastIsUpdate: Bindable<Bool> { get }
    var forecastCityName: Bindable<String> { get }
    var forecastCurrentDegrees: Bindable<String?> { get }
    var addToFavouritesButtonIsHidden: Bindable<Bool> { get }
    var cancelButtonIsHidden: Bindable<Bool> { get }
    var showFavouritesButtonIsHidden: Bindable<Bool> { get }
    var gradientType: Bindable<((dayTime: VisualWeatherModel.DayTime,
                                weatherState: VisualWeatherModel.WeatherState))> { get }
    var cityForecastForAddToFavourites: Bindable<Forecast?> { get }
    
    func addButtonPressed()
    func getCurrentCityName() -> String 
    func numberOfRowsInSection(for section: Int) -> Int
    func numberOfSections() -> Int
    func hourlyTableCellViewModelType() -> HourlyTableCellViewModelType?
    func dailyTableCellViewModelType(for indexPath: IndexPath) -> DailyTableCellViewModelType?
    func moreInfoTableCellViewModelType() -> MoreInfoTableCellViewModelType?
    func sectionType(for section: Int) -> WeatherTableSectionsType
}

