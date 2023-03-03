import Foundation

protocol FavoritesServiceProtocol: AnyObject {
    var forecastDidSaveCallBack: ((Forecast) -> ())? { get set }
    func save(forecast: Forecast)
    func remove(forecast: Forecast)
    func getFavoritesForecasts() -> [Forecast]
    func isAlreadySaved(_ coordinate: CityInfo.Coordinate) -> Bool
}

final class FavoritesService: FavoritesServiceProtocol {
    
    var forecastDidSaveCallBack: ((Forecast) -> ())?
    
    private let coordinateFileName = "coordinates"
    private let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    private var savedCoordinates: [CityInfo.Coordinate] {
        guard
            let fileURL = documentsURL?.appendingPathComponent(coordinateFileName),
            let savedData = try? Data(contentsOf: fileURL),
            let savedFiles = try? JSONDecoder().decode([CityInfo.Coordinate].self, from: savedData) else { return [] }
        return savedFiles
    }
    
    func save(forecast: Forecast) {
        guard !isAlreadySaved(forecast.cityInfo.coordinate) else { return }
        
        let fileName = makeFileName(forecast.cityInfo.coordinate)
        var savedFiles = savedCoordinates
        savedFiles.append(forecast.cityInfo.coordinate)
        
        guard
            let coordinateFileURL = documentsURL?.appendingPathComponent(coordinateFileName),
            let forecastFileURL = documentsURL?.appendingPathComponent(fileName),
            let updateCoordinateData = try? JSONEncoder().encode(savedFiles),
            let forecastData = try? JSONEncoder().encode(forecast)
        else { return }
        
        guard let _ = try? updateCoordinateData.write(to: coordinateFileURL),
              let _ = try? forecastData.write(to: forecastFileURL)
        else { return }
        
        forecastDidSaveCallBack?(forecast)
    }
    
    func remove(forecast: Forecast) {
        var savedCoordinates = savedCoordinates
        savedCoordinates.removeAll {
            $0.lat == forecast.cityInfo.coordinate.lat
            && $0.lon == forecast.cityInfo.coordinate.lon
        }
        let fileName = makeFileName(forecast.cityInfo.coordinate)
        guard
            let savedCoordinatesFileURL = documentsURL?.appendingPathComponent(coordinateFileName),
            let savedForecastFileURL = documentsURL?.appendingPathComponent(fileName),
            let savedCoordinatesUpdateData = try? JSONEncoder().encode(savedCoordinates)
        else { return }
        
        try? savedCoordinatesUpdateData.write(to: savedCoordinatesFileURL)
        try? FileManager.default.removeItem(at: savedForecastFileURL)
    }
    
    func isAlreadySaved(_ coordinate: CityInfo.Coordinate) -> Bool {
        return savedCoordinates.contains {
            $0.lon == coordinate.lon
            && $0.lat == coordinate.lat
        }
    }
    
    func getFavoritesForecasts() -> [Forecast] {
        var favoritesForecasts = [Forecast]()
        
        savedCoordinates.enumerated().forEach { index, savedCoordinate in
            let fileName = makeFileName(savedCoordinate)
            guard
                let savedForecastFileURL = documentsURL?.appendingPathComponent(fileName),
                let savedForecastData = try? Data(contentsOf: savedForecastFileURL),
                let savedForecast = try? JSONDecoder().decode(Forecast.self, from: savedForecastData)
            else { return }
            
            favoritesForecasts.append(savedForecast)
        }
        
        return favoritesForecasts
    }
    
    private func makeFileName(_ coordinate: CityInfo.Coordinate) -> String {
        return coordinate.lat + coordinate.lon
    }
}
