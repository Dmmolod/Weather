import Foundation
import UIKit

struct CityInfo: Codable {
    
    var countryEn: String
    var countryRu: String
    var cityEn: String
    var cityRu: String
    var coordinate: Coordinate
    
    struct Coordinate: Codable {
        var lat: String
        var lon: String
    }
}

struct CityInfoModel: Decodable {
    let country_en: String
    let country: String
    let city_en: String
    let city: String
    let lat: Double
    let lng: Double
    
    func convertToCityInfo() -> CityInfo {
        return CityInfo(countryEn: country_en,
                        countryRu: country,
                        cityEn: city_en,
                        cityRu: city,
                        coordinate: CityInfo.Coordinate(lat: String(lat),
                                                        lon: String(lng)))
    }
}

extension CityInfo.Coordinate {
    var fileName: String {
        return self.lat + self.lon
    }
}
