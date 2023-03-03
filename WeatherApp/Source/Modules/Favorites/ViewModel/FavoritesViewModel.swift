import Foundation

final class SearchCityManager {
    func didGetText(_ text: String) {}
}

protocol FavoritesViewModelType: AnyObject, ResultTableViewModelProtocol, SearchFieldViewModelProtocol {
    var selectedCityCoordinate: Bindable<CityInfo?> { get }
    var selectedFavoriteCity: Bindable<Forecast?> { get }
    var shadowEffectIsHide: Bindable<Bool> { get }
    var hideKeyboardRecognizerIsEnable: Bindable<Bool> { get }
    var endEditing: Bindable<Bool> { get }
    var selectedCellIndexPath: IndexPath? { get }
    
    //MARK: - Life Cycle
    func viewDidAppear()
    func viewDidDisappear()
}

protocol SearchFieldViewModelProtocol {
    var searchIsActive: Bindable<Bool> { get }
    var searchFieldText: Bindable<String?> { get }
    func searchFieldShouldBeginEditind(with text: String?)
    func textInput(_ text: String?, replacementString string: String)
    func searchFieldShouldClear()
    func searchFieldShouldReturn()
    func cancelSearch()
}

class FavoritesViewModel: FavoritesViewModelType {
    private let updateGroup = DispatchGroup()
    
    private let favoritesService: FavoritesServiceProtocol
    private let updateChecker: FavoritesListUpdateChecker
    private let oneCallApiClient: OneCallApiClientProtocol
    
    let needUpdateTable = Bindable<Void>(())
    let resultTableModel = Bindable<ResultTableViewModel>(.favorites(items: []))
    let iconService: WeatherIconService
    
    let selectedCityCoordinate = Bindable<CityInfo?>(nil)
    let selectedFavoriteCity = Bindable<Forecast?>(nil)
    let shadowEffectIsHide = Bindable<Bool>(true)
    let hideKeyboardRecognizerIsEnable = Bindable<Bool>(false)
    let endEditing = Bindable<Bool>(false)
    var selectedCellIndexPath: IndexPath?
    
    let searchIsActive = Bindable<Bool>(false)
    let searchFieldText = Bindable<String?>(nil)
    
    private var cities: [CityInfo]
    private var currentLocationForecast: Forecast?
    private var forecastsList = [Forecast]()
    private var filteredCities = [CityInfo]()
    
    private var forecastCellViewModels: [FavoriteCellViewModel] {
        return forecastsList.enumerated().map {
            .make(
                $1,
                isCurrentLocationCity: $0 == 0 && currentLocationForecast != nil,
                iconService: iconService
            )
        }
    }
    
    init(
        currentLocationForecast: Forecast? = nil,
        favoritesService: FavoritesServiceProtocol,
        iconService: WeatherIconService,
        oneCallApiClient: OneCallApiClientProtocol,
        updateChecker: FavoritesListUpdateChecker = FavoritesListUpdateChecker()
    ) {
        self.currentLocationForecast = currentLocationForecast
        self.favoritesService = favoritesService
        self.iconService = iconService
        self.updateChecker = updateChecker
        self.oneCallApiClient = oneCallApiClient
        self.cities = CitiesParseService.shared.allCities
        
        updateChecker.needUpdateCallBack = { [weak self] in
            self?.updateForecastList()
        }
        
        favoritesService.forecastDidSaveCallBack = { [weak self] savedForecast in
            self?.didAddToFavorites(savedForecast)
        }
        
        configureFavoritesList()
    }
    
    //MARK: - Life cycle
    func viewDidAppear() {
        //        updateChecker.start()
    }
    
    func viewDidDisappear() {
        //        updateChecker.stop()
    }
    
    //MARK: - Helpers
    private func configureFavoritesList() {
        if let currentForecast = currentLocationForecast {
            forecastsList.append(currentForecast)
        }
        
        let localFavorites = favoritesService.getFavoritesForecasts()
        forecastsList.append(contentsOf: localFavorites)
        
        resultTableModel.value = .favorites(
            items: forecastsList.enumerated().map {
                .make(
                    $1,
                    isCurrentLocationCity: $0 == 0 && currentLocationForecast != nil,
                    iconService: iconService
                )
            }
        )
        updateForecastList()
        needUpdateTable.value = ()
    }
    
    private func updateForecastList() {
        forecastsList.enumerated().forEach { index, forecast in
            
            updateGroup.enter()
            oneCallApiClient.fetchForcast(
                lat: forecast.cityInfo.coordinate.lat,
                lon: forecast.cityInfo.coordinate.lon,
                completion: { [weak self] result in
                    guard let updatedForecastResponse = try? result.get()
                    else {
                        self?.updateGroup.leave()
                        return
                    }
                    
                    let updatedForecast: Forecast = .make(
                        updatedForecastResponse,
                        cityInfo: forecast.cityInfo
                    )
                    
                    self?.forecastsList[index] = updatedForecast
                    self?.updateGroup.leave()
                }
            )
        }
        
        updateGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.resultTableModel.value = .favorites(items: self.forecastCellViewModels)
            self.needUpdateTable.value = ()
        }
    }
    
    private func didAddToFavorites(_ forecast: Forecast) {
        self.forecastsList.append(forecast)
        cancelSearch()
    }
    
    private func filterSearch(_ searchText: String) {
        filteredCities = cities
            .filter {
                $0.cityEn.lowercased().contains(searchText.lowercased())
                || $0.cityRu.lowercased().contains(searchText.lowercased())
            }
            .sorted { cityInfo, _ in
                cityInfo.cityEn.hasPrefix(searchText)
                || cityInfo.cityRu.hasPrefix(searchText)
                && cityInfo.countryEn == "Russia"
            }
        
        let searchModels = filteredCities.map { SearchCellViewModel($0) }
        resultTableModel.value = .search(items: searchModels)
        needUpdateTable.value = ()
    }
    
    func hideKeyboard() {
        endEditing.value = true
        searchIsActive.value = false
        shadowEffectIsHide.value = true
        hideKeyboardRecognizerIsEnable.value = false
    }
}

extension FavoritesViewModel: SearchFieldViewModelProtocol {
    
    func searchFieldShouldBeginEditind(with text: String?) {
        switch resultTableModel.value {
        case .search:
            shadowEffectIsHide.value = true
            hideKeyboardRecognizerIsEnable.value = false
        case .favorites:
            shadowEffectIsHide.value = false
            hideKeyboardRecognizerIsEnable.value = true
        }
        
        searchIsActive.value = true
    }
    
    func textInput(_ text: String?, replacementString string: String) {
        guard var text else { return }
        let isAllTextClear = text.count == 1 && string.isEmpty
        
        if isAllTextClear {
            resultTableModel.value = .favorites(items: forecastCellViewModels)
            needUpdateTable.value = ()
            
            shadowEffectIsHide.value = false
            hideKeyboardRecognizerIsEnable.value = true
            return
        }
        
        if string.isEmpty { text.removeLast() }
        else { text += string }
        
        hideKeyboardRecognizerIsEnable.value = false
        shadowEffectIsHide.value = true
        
        filterSearch(text)
    }
    
    func searchFieldShouldClear() {
        hideKeyboardRecognizerIsEnable.value = true
        shadowEffectIsHide.value = false
        resultTableModel.value = .favorites(items: forecastCellViewModels)
        needUpdateTable.value = ()
    }
    
    func searchFieldShouldReturn() {
        hideKeyboard()
    }
    
    func cancelSearch() {
        hideKeyboard()
        searchFieldText.value = nil
        resultTableModel.value = .favorites(items: forecastCellViewModels)
        needUpdateTable.value = ()
    }
}

extension FavoritesViewModel: ResultTableViewModelProtocol {
    
    func didSelectRow(at indexPath: IndexPath) {
        switch resultTableModel.value {
            
        case .search:
            guard indexPath.row < filteredCities.count else { return }
            selectedCityCoordinate.value = filteredCities[indexPath.row]
        case .favorites:
            guard indexPath.section < forecastsList.count else { return }
            selectedCellIndexPath = indexPath
            selectedFavoriteCity.value = forecastsList[indexPath.section]
        }
    }
    
    func deleteFavorite(at indexPath: IndexPath, onSuccess: @escaping () -> ()) {
        guard indexPath.section < forecastsList.count else { return }
        guard resultTableModel.value.info.editingStyle == .delete else { return }
        
        let removedForecast = forecastsList.remove(at: indexPath.section)
        favoritesService.remove(forecast: removedForecast)
        
        resultTableModel.value = .favorites(items: forecastCellViewModels)
        
        onSuccess()
    }
    
    func canEditRow(at indexPath: IndexPath) -> Bool {
        switch (resultTableModel.value, indexPath.section) {
        case (.favorites, 0) where currentLocationForecast != nil: return false
        case (.search, _): return false
            
        default: return true
        }
    }
}
