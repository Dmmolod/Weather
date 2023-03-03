import UIKit

protocol WeatherViewModelType: AnyObject {
    var forecastCityName: Bindable<String> { get }
    var forecastCurrentDegrees: Bindable<String> { get }
    var isModelLoaded: Bindable<Bool> { get }
    var gradientType: Bindable<VisualWeatherModel> { get }
    var addToFavoritesButtonIsHidden: Bindable<Bool> { get }
    var cancelButtonIsHidden: Bindable<Bool> { get }
    var showFavoritesButtonIsHidden: Bindable<Bool> { get }
    func addButtonPressed()
    func viewDidLoad()
}

typealias WeatherViewModel = WeatherViewModelType & WeatherTableViewModel

final class WeatherViewModelImpl: WeatherViewModel {
    
    let weatherIconManager: WeatherIconManager
    private let oneCallApiClient: OneCallApiClientProtocol
    private let favoritesManager: FavoritesManagerProtocol
    
    let forecastCellModels = Bindable<[WeatherTableCellModel]>([])
    let forecastCityName = Bindable<String>("- -")
    let forecastCurrentDegrees = Bindable<String>("- -")
    let isModelLoaded = Bindable<Bool>(false)
    
    let gradientType = Bindable<VisualWeatherModel>(
        VisualWeatherModel(
            dayTime: .day,
            weatherState: .clear
        )
    )
    
    let addToFavoritesButtonIsHidden = Bindable<Bool>(true)
    let cancelButtonIsHidden = Bindable<Bool>(true)
    let showFavoritesButtonIsHidden = Bindable<Bool>(false)
    
    private let loadModel: ForecastLoadModel
    private let isPresentationStyle: Bool
    private var forecast: Forecast?
    
    init(
        loadModel: ForecastLoadModel,
        oneCallApiClient: OneCallApiClientProtocol,
        favoritesManager: FavoritesManagerProtocol,
        weatherIconManager: WeatherIconManager,
        isPresentationStyle: Bool = false
    ) {
        self.oneCallApiClient = oneCallApiClient
        self.favoritesManager = favoritesManager
        self.weatherIconManager = weatherIconManager
        self.loadModel = loadModel
        self.isPresentationStyle = isPresentationStyle
        
        if isPresentationStyle == true {
            showFavoritesButtonIsHidden.value = true
            cancelButtonIsHidden.value = false
        }
    }
    
    func viewDidLoad() {
        switch loadModel {
        case let .forecast(model): setForecast(model)
        case let .cityInfo(info): getForecast(from: info)
        }
    }
    
    func addButtonPressed() {
        guard let forecast else { return }
        favoritesManager.save(forecast: forecast)
    }
        
    //MARK: - Setup forecast methods
    private func getForecast(from cityInfo: CityInfo) {
        
        oneCallApiClient.fetchForcast(
            lat: cityInfo.coordinate.lat,
            lon: cityInfo.coordinate.lon,
            completion: { [weak self] result in
                guard let self = self,
                      let forecastResponse = try? result.get() else { return }
                
                let forecast: Forecast = .make(
                    forecastResponse,
                    cityInfo: cityInfo
                )
                
                self.setForecast(forecast)
            }
        )
    }
    
    private func setForecast(_ forecast: Forecast) {
        self.forecast = forecast
        isModelLoaded.value = true
        setupValue()
    }
    
    private func setupValue() {
        guard let forecast = forecast else { return }
        updateTableModel(forecast)
        
        forecastCityName.value = forecast.cityName
        forecastCurrentDegrees.value = "\(forecast.current.temp)".withTempSymbol
        
        if isPresentationStyle == true {
            addToFavoritesButtonIsHidden.value = favoritesManager.isAlreadySaved(forecast.cityInfo.coordinate)
        }
        
        guard let currentTime = Int(forecast.current.date.format("H")),
              let weatherState = VisualWeatherModel.WeatherState(rawValue: forecast.current.weatherState.lowercased())
        else { return }
        
        let dayTimeType = VisualWeatherModel.dayType(from: currentTime)
        
        gradientType.value = VisualWeatherModel(
            dayTime: dayTimeType,
            weatherState: weatherState
        )
    }
    
    private func updateTableModel(_ forecast: Forecast) {
        let hourlyCellViewModels = forecast.hourly.enumerated().map {
            HourCollectionCellViewModel(
                $1,
                isCurrentHour: $0 == 0,
                iconManager: weatherIconManager
            )
        }
        let dailyCellViewModels = forecast.daily.enumerated().map {
            DailyTableCellViewModel(
                $1,
                isCurrentDay: $0 == 0,
                iconManager: weatherIconManager
            )
        }
        
        forecastCellModels.value = [
            .hourlyCell(model: hourlyCellViewModels),
            .dailyCell(model: dailyCellViewModels),
            .moreCell(
                model: MoreInfoCellViewModel(
                    currentForecast: forecast.current,
                    infoCells: [
                        .feelsLike,
                        .humidity,
                        .pressure,
                        .windSpeed
                    ]
                )
            )
        ]
    }
}
