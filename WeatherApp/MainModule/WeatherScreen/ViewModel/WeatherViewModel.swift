import Foundation

class WeatherViewModel: WeatherViewModelType {

    private var networkManager = NetworkManager()

    var transitionCellIndexPath = IndexPath(row: 0, section: 0)
    
    let forecastIsUpdate = Bindable<Bool>(false)
    let forecastCityName = Bindable<String>("")
    let forecastCurrentDegrees = Bindable<String?>(nil)
    let addToFavouritesButtonIsHidden = Bindable<Bool>(true)
    let cancelButtonIsHidden = Bindable<Bool>(true)
    let showFavouritesButtonIsHidden = Bindable<Bool>(false)
    let gradientType = Bindable<(dayTime: VisualWeatherModel.DayTime,
                                 weatherState: VisualWeatherModel.WeatherState)>((dayTime: .day,
                                                                                 weatherState: .clear))
    let cityForecastForAddToFavourites = Bindable<Forecast?>(nil)
    
    private let isPresentationStyle: Bool
    private var forecast: Forecast?
    
    init(_ forecast: Forecast,
         _ transitionCellIndexPath: IndexPath = IndexPath(row: 0, section: 0),
         _ isPresentationStyle: Bool = false) {
        
        self.transitionCellIndexPath = transitionCellIndexPath
        self.isPresentationStyle = isPresentationStyle
        setForecast(forecast)
    }
    
    init(_ cityInfo: CityInfo, isPresentationStyle: Bool) {
        
        self.isPresentationStyle = isPresentationStyle
        
        getForecast(from: cityInfo)
        
        if isPresentationStyle == true {
            showFavouritesButtonIsHidden.value = true
            cancelButtonIsHidden.value = false
        }
    }
    
    func addButtonPressed() {
        cityForecastForAddToFavourites.value = forecast
    }
        
    // MARK: Setup forecast methods
    
    private func getForecast(from cityInfo: CityInfo) {
        
        networkManager.getForecast(from: cityInfo, completionQueue: .main) { [weak self] result in
            guard let self = self,
                  let forecast = try? result.get() else { return }
            
            self.setForecast(forecast)
        }
    }
    
    private func setForecast(_ forecast: Forecast) {
        self.forecast = forecast
        setupValue()
    }
    
    private func setupValue() {
        guard let forecast = forecast else { return }
        
        forecastCityName.value = forecast.cityName
        forecastCurrentDegrees.value = String(forecast.current.temp).withTempSymbol
        
        if isPresentationStyle == true {
            addToFavouritesButtonIsHidden.value = FavouritesManager.isAlreadySaved(forecast.cityInfo.coordinate)
        }

        guard let currentTime = Int(forecast.current.date.format("H")),
              let weatherState = VisualWeatherModel.WeatherState(rawValue: forecast.current.weatherState.lowercased()) else { return }
        
        let dayTimeType = VisualWeatherModel.dayType(from: currentTime)
        
        gradientType.value = (dayTime: dayTimeType,
                              weatherState: weatherState)
        
        self.forecastIsUpdate.value = true
    }
    
    func getCurrentCityName() -> String {
        return forecastCityName.value
    }
    
    // MARK: Table setup methods
    
    func numberOfRowsInSection(for section: Int) -> Int {
        switch WeatherTableSectionsType.allCases[section]  {
        case .hourly: return 1
        case .daily: return forecast?.daily.count ?? 0
        case .moreInfo: return 1
        }
    }
    
    func numberOfSections() -> Int {
        return WeatherTableSectionsType.allCases.count
    }
    
    func sectionType(for section: Int) -> WeatherTableSectionsType {
        switch WeatherTableSectionsType.allCases[section] {
        case .hourly: return .hourly
        case .daily: return .daily
        case .moreInfo: return .moreInfo
        }
    }
    
    func hourlyTableCellViewModelType() -> HourlyTableCellViewModelType? {
        guard let hourlyForecast = forecast?.hourly else {
            return nil
        }
        
        return HourlyTableCellViewModel(hourlyForecast: hourlyForecast)
    }
    
    func dailyTableCellViewModelType(for indexPath: IndexPath) -> DailyTableCellViewModelType? {
        guard let dailyForecast = forecast?.daily else { return nil }
        
        return DailyTableCellViewModel(dailyForecast[indexPath.row], isCurrentDay: indexPath.row == 0)
    }
    
    func moreInfoTableCellViewModelType() -> MoreInfoTableCellViewModelType? {
        guard let forecast = forecast else { return nil }
        
        return MoreInfoTableCellViewModel(forecast.current)
    }
}
