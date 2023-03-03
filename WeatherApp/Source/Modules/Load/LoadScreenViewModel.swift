import CoreLocation

final class LoadScreenViewModel: NSObject {

    private let coordinator: LoadScreenCoordinatorLogic
    
    private let oneCallApiClient: OneCallApiClientProtocol
    private let locationManager: CLLocationManager
    
    private var loadIsPossible: Bool = true

    init(
        oneCallApiClient: OneCallApiClientProtocol,
        coordinator: LoadScreenCoordinatorLogic,
        locationManager: CLLocationManager
    ) {
        self.oneCallApiClient = oneCallApiClient
        self.coordinator = coordinator
        self.locationManager = locationManager
    }
    
    private func fetchForecast(with location: CLLocation) {
        if !loadIsPossible { return }
        loadIsPossible = false
        
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, error in
            
            let cityInfo = CityInfo(
                countryEn: placemarks?.first?.country ?? "",
                countryRu: placemarks?.first?.country ?? "",
                cityEn: placemarks?.first?.locality ?? "",
                cityRu: placemarks?.first?.locality ?? "",
                coordinate: CityInfo.Coordinate(
                    lat: String(location.coordinate.latitude),
                    lon: String(location.coordinate.longitude)
                )
            )
            
            self?.oneCallApiClient.fetchForcast(
                lat: cityInfo.coordinate.lat,
                lon: cityInfo.coordinate.lon,
                completion: { result in
                    switch result {
                    case let .success(forecast):
                        self?.didGetForecast(with: forecast, and: cityInfo)
                    case let .failure(error):
                        print(error)
                        self?.coordinator.didFinishFetchForecast(nil)
                    }
                }
            )
        }
    }
    
    func viewDidLoad() {
        if checkAuthorizationStatus() {
            setupLocationManager()
        }
    }
    
    private func didGetForecast(
        with model: ForecastResponse,
        and cityInfo: CityInfo
    ) {
        let forecast: Forecast =  .make(model, cityInfo: cityInfo)
        coordinator.didFinishFetchForecast(forecast)
    }
    
    private func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    @discardableResult
    private func checkAuthorizationStatus() -> Bool {
        if locationManager.authorizationStatus == .denied {
            coordinator.didFinishFetchForecast(nil)
            return false
        }
        return true
    }
}

extension LoadScreenViewModel: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorizationStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        guard let location = manager.location else { return }
        
        fetchForecast(with: location)
    }
}
