import Foundation

class FavouritesViewModel: FavouritesViewModelType {
    
    typealias FavouritesEnumerated = (forecast: Forecast, correctIndex: Int)
    
    private let favouritesManager: FavouritesManagerProtocol
    private let networkManager: NetworkManagerProtocol
    
    let selectedCityCoordinate = Bindable<CityInfo?>(nil)
    let selectedFavouriteCity = Bindable<Forecast?>(nil)
    let searchIsActive = Bindable<Bool>(false)
    let shadowEffectIsHide = Bindable<Bool>(true)
    let hideKeyboardRecognizerIsEnable = Bindable<Bool>(false)
    let endEditing = Bindable<Bool>(false)
    let searchFieldText = Bindable<String?>(nil)
    let tableIsUpdate = Bindable<Bool>(false)
    var selectedCellIndexPath: IndexPath?
    
    private var cities: [CityInfo]
    private var currentLocationForecast: Forecast?
    private var tempFavouritesList = [FavouritesEnumerated]()
    private var forecastsList = [Forecast]()
    private var filteredCities = [CityInfo]()
    private var lastUpdateDate: Date
    private var updateForecastTimer: Timer?
    
    private var tableStyle: FavouritesTableType = .favourites {
        didSet {
            tableIsUpdate.value = true
        }
    }
    
    init(_ currentLocationForecast: Forecast?, _ favouritesManager: FavouritesManagerProtocol, _ networkManager: NetworkManagerProtocol) {
        self.currentLocationForecast = currentLocationForecast
        self.favouritesManager = favouritesManager
        self.networkManager = networkManager
        self.cities = CitiesParseManager.shared.allCities
        self.lastUpdateDate = Date()
        
        getFavouritesList()
    }
    
    // MARK: Update forecast methods
    
    func startUpdateTimer() {
        let currentDate = Date()
        var timerFireDate: Date { return Date().addingTimeInterval(Double(60 - currentDate.second)) }
        
        if lastUpdateDate < currentDate && lastUpdateDate.minute < currentDate.minute {
            updateForecastList()
            lastUpdateDate = currentDate
        }
        
        updateForecastTimer = Timer(fire: timerFireDate, interval: 60, repeats: true, block: { [weak self] timer in
            self?.updateForecastList()
        })
        guard let updateForecastTimer = updateForecastTimer else { return }
        RunLoop.main.add(updateForecastTimer, forMode: .default)
    }
    
    func killUpdateTimer() {
        updateForecastTimer?.invalidate()
        updateForecastTimer = nil
    }
    
    private func updateForecastList() {
        let updateGroup = DispatchGroup()
        forecastsList.enumerated().forEach { [weak self] index, forecast in
            guard let self = self else { return }
            updateGroup.enter()
            self.networkManager.getForecast(from: forecast.cityInfo, completionQueue: .main) { result in
                guard let updatedForecast = try? result.get() else { updateGroup.leave() ; return}
                self.forecastsList.remove(at: index)
                self.forecastsList.insert(updatedForecast, at: index)
                updateGroup.leave()
            }
        }
        updateGroup.notify(queue: .main) {
            self.tableIsUpdate.value = true
        }
    }
    
    // MARK: Work with model
    
    func addToFavourites(_ forecast: Forecast) {
        self.forecastsList.append(forecast)
        self.favouritesManager.save(forecast: forecast)
        cancelSearch()
    }
    
    private func getFavouritesList() {
        if let currentForecast = currentLocationForecast {
            forecastsList.append(currentForecast)
        }
        forecastsList.append(contentsOf: favouritesManager.getFavouritesForecasts())

        updateForecastList()
    }
    
    // MARK: Work with searchField
    
    func searchFieldShouldBeginEditind(with text: String?) {

        shadowEffectIsHide.value = tableStyle == .search
        hideKeyboardRecognizerIsEnable.value = tableStyle == .favourites
        searchIsActive.value = true
    }
    
    func textInput(_ text: String?, replacementString string: String) {
        guard var text = text else { return }
        let isAllTextClear = text.count == 1 && string.isEmpty
        
        if isAllTextClear {
            tableStyle = .favourites
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
        tableStyle = .favourites
    }
    func searchFieldShouldReturn() {
        hideKeyboard()
    }
    
    func cancelSearch() {
        hideKeyboard()
        searchFieldText.value = nil
        tableStyle = .favourites
    }
    
    func hideKeyboard() {
        endEditing.value = true
        searchIsActive.value = false
        shadowEffectIsHide.value = true
        hideKeyboardRecognizerIsEnable.value = false
    }
    
    // MARK: Work with model
    
    private func filterSearch(_ searchText: String) {
        
        filteredCities = cities.filter({
            $0.cityEn.lowercased().contains(searchText.lowercased()) || $0.cityRu.lowercased().contains(searchText.lowercased())
        }).sorted(by: { cityInfo, _ in
            if ( cityInfo.cityEn.hasPrefix(searchText) || cityInfo.cityRu.hasPrefix(searchText) ) && cityInfo.countryEn == "Russia" { return true }
            return false
        })
        tableStyle = .search
    }
    
    // MARK: Work with table
    
    func getIndexPath(for cityName: String) -> IndexPath? {
        guard let index = forecastsList.firstIndex(where: { $0.cityName == cityName }) else { return nil }
        return IndexPath(row: 0, section: index)
    }
    
    func currentTableStyle() -> FavouritesTableType {
        return tableStyle
    }
    
    func favouriteCityCellViewModel(for indexPath: IndexPath) -> FavouriteCityCellViewModel? {
        guard indexPath.section < forecastsList.count else { return nil }
        
        let cityForecast = forecastsList[indexPath.section]
        let isCurrentDay = indexPath.section == 0 && currentLocationForecast != nil
        return FavouriteCityCellViewModel(cityForecast, isCurrentDay, networkManager)
    }
    
    func searchCellViewModel(for indexPath: IndexPath) -> SearchCellViewModel? {
        guard indexPath.row < filteredCities.count else { return nil }
        
        return SearchCellViewModel(filteredCities[indexPath.row])
    }
    
    func numberOfSections() -> Int {
        switch tableStyle {
        case .search: return 1
        case .favourites: return forecastsList.count
        }
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch tableStyle {
        case .search: return filteredCities.count < Constans.maxResultCount ? filteredCities.count : Constans.maxResultCount
        case .favourites: return 1
        }
    }
    
    func canEditRow(at indexPath: IndexPath) -> Bool {
        switch tableStyle {
        case .search: return false
        case .favourites:
            if indexPath.section == 0 && currentLocationForecast != nil {
                return false
            }
            return true
        }
    }
    
    func deleteFavouriteCity(at indexPath: IndexPath) {
        guard indexPath.section < forecastsList.count else { return }
        
        let removedForecast = forecastsList.remove(at: indexPath.section)
        favouritesManager.remove(forecast: removedForecast)
    }
    
    func didSelect(at indexPath: IndexPath) {
        switch tableStyle {
        
        case .search:
            guard indexPath.row < filteredCities.count else { return }
            selectedCityCoordinate.value = filteredCities[indexPath.row]
        case .favourites:
            guard indexPath.section < forecastsList.count else { return }
            selectedCellIndexPath = indexPath
            selectedFavouriteCity.value = forecastsList[indexPath.section]
        }
    }
}
