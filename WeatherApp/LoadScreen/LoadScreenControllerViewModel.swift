import Foundation
import CoreLocation

class LoadScreenControllerViewModel {

    let networkManager = NetworkManager()
    let currentLocationForecast = Bindable<Forecast?>(nil)

    func didGet(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            
            let cityInfo = CityInfo(countryEn: placemarks?.first?.country ?? "",
                                    countryRu: placemarks?.first?.country ?? "",
                                    cityEn: placemarks?.first?.locality ?? "",
                                    cityRu: placemarks?.first?.locality ?? "",
                                    coordinate: CityInfo.Coordinate(lat: String(location.coordinate.latitude),
                                                                    lon: String(location.coordinate.longitude)))
            
            self.networkManager.getForecast(from: cityInfo, completionQueue: .main) { [weak self] result in
                let currentLocationForecast = try? result.get()
                self?.currentLocationForecast.value = currentLocationForecast
            }
        }
    }
}
