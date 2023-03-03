//
//  CityInfoModel.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 03.03.2023.
//

import Foundation

struct CityInfo: Codable {
    
    struct Coordinate: Codable {
        let lat: String
        let lon: String
    }
    
    let countryEn: String
    let countryRu: String
    let cityEn: String
    let cityRu: String
    let coordinate: Coordinate
    
    enum CodingKeys: String, CodingKey {
        case countryEn = "country_en"
        case cityEn = "city_en"
        case countryRu = "country"
        case cityRu = "city"
        case lat
        case lng
    }
    
    init(
        countryEn: String,
        countryRu: String,
        cityEn: String,
        cityRu: String,
        coordinate: Coordinate
    ) {
        self.countryEn = countryEn
        self.countryRu = countryRu
        self.cityEn = cityEn
        self.cityRu = cityRu
        self.coordinate = coordinate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.countryEn = try container.decode(String.self, forKey: .countryEn)
        self.countryRu = try container.decode(String.self, forKey: .countryRu)
        self.cityEn = try container.decode(String.self, forKey: .cityEn)
        self.cityRu = try container.decode(String.self, forKey: .cityRu)
        
        let lon = try container.decode(Double.self, forKey: .lng)
        let lat = try container.decode(Double.self, forKey: .lat)
        
        self.coordinate = Coordinate(
            lat: String(lat),
            lon: String(lon)
        )
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CityInfo.CodingKeys.self)
        
        guard let lat = Double(coordinate.lat),
              let lng = Double(coordinate.lon)
        else { throw NSError(domain: "failed to encode coordinates", code: 101) }
        
        try container.encode(lat, forKey: .lat)
        try container.encode(lng, forKey: .lng)
        try container.encode(countryEn, forKey: .countryEn)
        try container.encode(countryRu, forKey: .countryRu)
        try container.encode(cityEn, forKey: .cityEn)
        try container.encode(cityRu, forKey: .cityRu)
    }
}
