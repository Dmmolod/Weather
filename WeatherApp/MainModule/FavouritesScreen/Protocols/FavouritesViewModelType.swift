import Foundation

protocol FavouritesViewModelType {
    
    var selectedCityCoordinate: Bindable<CityInfo?> { get }
    var selectedFavouriteCity: Bindable<Forecast?> { get }
    var searchIsActive: Bindable<Bool> { get }
    var shadowEffectIsHide: Bindable<Bool> { get }
    var hideKeyboardRecognizerIsEnable: Bindable<Bool> { get }
    var endEditing: Bindable<Bool> { get }
    var searchFieldText: Bindable<String?> { get }
    var tableIsUpdate: Bindable<Bool> { get }
    var selectedCellIndexPath: IndexPath? { get }
    
    // MARK: Timer for update forecast methods
    func startUpdateTimer()
    func killUpdateTimer()
    
    // MARK: Search field methods
    func searchFieldShouldBeginEditind(with text: String?)
    func textInput(_ text: String?, replacementString string: String)
    func searchFieldShouldClear()
    func searchFieldShouldReturn()
    func cancelSearch()
    func hideKeyboard()
    
    // MARK: add to favourites
    func addToFavourites(_ forecast: Forecast)
    
    // MARK: Table methods
    func getIndexPath(for cityName: String) -> IndexPath?
    func currentTableStyle() -> FavouritesTableType
    func favouriteCityCellViewModel(for indexPath: IndexPath) -> FavouriteCityCellViewModel?
    func searchCellViewModel(for indexPath: IndexPath) -> SearchCellViewModel?
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func canEditRow(at indexPath: IndexPath) -> Bool
    func deleteFavouriteCity(at indexPath: IndexPath)
    func didSelect(at indexPath: IndexPath)
}
