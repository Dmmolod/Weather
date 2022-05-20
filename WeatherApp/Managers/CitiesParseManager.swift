import Foundation

class CitiesParseManager {
    
    static let shared = CitiesParseManager()
    
    private init() {}
        
    var allCities: [CityInfo] = {
        guard let cityJsonDataURL = Bundle.main.url(forResource: "CityJsonData", withExtension: ".json"),
              let data = try? Data(contentsOf: cityJsonDataURL, options: .mappedIfSafe),
              let cities = (try? JSONDecoder().decode([CityInfoModel].self, from: data))?.map({ $0.convertToCityInfo() }) else { return [] }
        
        return cities
    }()
}


