import Foundation

protocol FavouritesManagerProtocol {
    
    func save(forecast: Forecast)
    func remove(forecast: Forecast)
    func getFavouritesForecasts() -> [Forecast]
    static func isAlreadySaved(_ coordinate: CityInfo.Coordinate) -> Bool
}

class FavouritesManager: FavouritesManagerProtocol {
    
    private static let coordinateFileName = "coordinates"
    private static let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    private static var savedCoordinates: [CityInfo.Coordinate] {
        guard let fileURL = documentsURL?.appendingPathComponent(coordinateFileName),
              let savedData = try? Data(contentsOf: fileURL),
              let savedFiles = try? JSONDecoder().decode([CityInfo.Coordinate].self, from: savedData) else { return [] }
        return savedFiles
    }
    
    func save(forecast: Forecast) {
        
        guard !Self.isAlreadySaved(forecast.cityInfo.coordinate) else { return }
        
        var savedFiles = Self.savedCoordinates
        savedFiles.append(forecast.cityInfo.coordinate)
        
        guard let coordinateFileURL = Self.documentsURL?.appendingPathComponent(Self.coordinateFileName),
              let forecastFileURL = Self.documentsURL?.appendingPathComponent(forecast.cityInfo.coordinate.fileName),
              let updateCoordinateData = try? JSONEncoder().encode(savedFiles),
              let forecastData = try? JSONEncoder().encode(forecast) else { return }
        
        try? updateCoordinateData.write(to: coordinateFileURL)
        try? forecastData.write(to: forecastFileURL)
    }
    
    func remove(forecast: Forecast) {
        var savedCoordinates = Self.savedCoordinates
        savedCoordinates.removeAll { $0.lat == forecast.cityInfo.coordinate.lat && $0.lon == forecast.cityInfo.coordinate.lon }
        
        guard let savedCoordinatesFileURL = Self.documentsURL?.appendingPathComponent(Self.coordinateFileName),
              let savedForecastFileURL = Self.documentsURL?.appendingPathComponent(forecast.cityInfo.coordinate.fileName),
              let savedCoordinatesUpdateData = try? JSONEncoder().encode(savedCoordinates) else { return }
        
        try? savedCoordinatesUpdateData.write(to: savedCoordinatesFileURL)
        try? FileManager.default.removeItem(at: savedForecastFileURL)
    }
    
    static func isAlreadySaved(_ coordinate: CityInfo.Coordinate) -> Bool {
        return savedCoordinates.contains { $0.lon == coordinate.lon && $0.lat == coordinate.lat }
    }
    
    func getFavouritesForecasts() -> [Forecast] {
        var favouritesForecasts = [Forecast]()
        Self.savedCoordinates.enumerated().forEach({ index, savedCoordinate in
            
            guard let savedForecastFileURL = Self.documentsURL?.appendingPathComponent(savedCoordinate.fileName),
                  let savedForecastData = try? Data(contentsOf: savedForecastFileURL),
                  let savedForecast = try? JSONDecoder().decode(Forecast.self, from: savedForecastData) else { return }
            
            favouritesForecasts.append(savedForecast)
        })
        return favouritesForecasts
    }
}
