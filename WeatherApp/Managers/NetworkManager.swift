import Foundation
import UIKit

protocol NetworkManagerProtocol {
    
    func getForecast(from cityInfo: CityInfo, completionQueue: DispatchQueue,
                     forecastRequestCompletion: @escaping (Result<Forecast, Error>) -> Void)
    
    func getIcon(for iconID: String, completionQueue: DispatchQueue, completion: @escaping (Result<UIImage?, Error>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    
    private let apiHost = "https://api.openweathermap.org"
    private let oneCallAPIPath = "/data/2.5/onecall"
    private let apiKey = "appid=a25c2c1b483bc79218f30e9f8d75c317"
    
    func getForecast(from cityInfo: CityInfo, completionQueue: DispatchQueue,
                     forecastRequestCompletion: @escaping (Result<Forecast, Error>) -> Void) {
        
        
        let coordItem = "lat=\(cityInfo.coordinate.lat)&lon=\(cityInfo.coordinate.lon)"
        guard let forecastRequestURL = URL(string: apiHost + oneCallAPIPath + "?\(apiKey)&\(coordItem)&lang=\("en".localized)&exclude=minutely,alerts&units=metric") else { return }
            URLSession.shared.dataTask(with: forecastRequestURL) { data, _, error in
                guard error == nil, let data = data,
                      let forecastResponse = try? JSONDecoder().decode(ForecastResponse.self, from: data) else { return }
                
                let forecast = forecastResponse.convertToForecastType(with: cityInfo.cityRu, cityInfo)
                completionQueue.async {
                    forecastRequestCompletion(.success(forecast))
                }
            }.resume()
        
    }
    
    func getIcon(for iconID: String, completionQueue: DispatchQueue, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        guard let url = URL(string: "https://openweathermap.org/img/wn/\(iconID)@2x.png") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil, let data = data,
                  let image = UIImage(data: data) else { return }
            completionQueue.async {
                completion(.success(image))
            }
        }.resume()
    }
}
