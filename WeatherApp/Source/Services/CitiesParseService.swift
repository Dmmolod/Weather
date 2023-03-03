import Foundation

final class CitiesParseService {
    
    static let shared = CitiesParseService()
    
    private init() {}
        
    var allCities: [CityInfo] = {
        guard let cityJsonDataURL = Bundle.main.url(forResource: "CityJsonData", withExtension: ".json"),
              let data = try? Data(contentsOf: cityJsonDataURL, options: .mappedIfSafe),
              let cities = try? JSONDecoder().decode([CityInfo].self, from: data) else { return [] }
        
        return cities
    }()
}


