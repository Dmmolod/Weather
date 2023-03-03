//
//  ForecastModel.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 18.01.2023.
//

import CoreLocation

struct Forecast: Codable {
    var cityName: String
    let cityInfo: CityInfo
    let current: CurrentForescast
    let hourly: [HourForecast]
    let daily: [DayForecast]
}

extension Forecast {
    static func make(
        _ model: ForecastResponse,
        cityInfo: CityInfo
    ) -> Forecast {
        Forecast(
            cityName: cityInfo.cityRu,
            cityInfo: cityInfo,
            current: .converted(model),
            hourly: .converted(model),
            daily: .converted(model)
        )
    }
}

struct CurrentForescast: Codable {
    let date: Date
    let temp: Int
    let humidity: Int
    let pressure: Double
    let feelsLike: Int
    let windSpeed: Int
    let iconID: String
    let description: String
    let weatherState: String
    
    enum CodingKeys: String, CodingKey {
        case date,
             temp,
             humidity,
             pressure,
             feelsLike,
             iconID,
             description,
             weatherState
        case windSpeed = "wind_speed"
    }
}

extension CurrentForescast{
    static func converted(_ model: ForecastResponse) -> CurrentForescast {
        CurrentForescast(
            date: model.current.dt.transformToDate(model.timezoneOffset),
            temp: Int(model.current.temp),
            humidity: Int(model.current.humidity),
            pressure: model.current.pressure,
            feelsLike: Int(model.current.feelsLike),
            windSpeed: Int(model.current.windSpeed),
            iconID: model.current.weather.first?.icon ?? "",
            description: model.current.weather.first?.description ?? "" ,
            weatherState: model.current.weather.first?.main ?? ""
        )
    }
}

struct DayForecast: Codable {
    
    let date: Date
    let tempMax: Int
    let tempMin: Int
    let iconID: String
    
    enum CodingKeys: String, CodingKey {
        case date, iconID
        case tempMax = "temp_max"
        case tempMin = "temp_min"
    }
}

extension Array where Element == DayForecast {
    static func converted(_ model: ForecastResponse) -> [Element] {
        model.daily.map { DayForecast(
            date: $0.dt.transformToDate(model.timezoneOffset),
            tempMax: Int($0.temp.max),
            tempMin: Int($0.temp.min),
            iconID: $0.weather.first?.icon ?? ""
        ) }
    }
}

struct HourForecast: Codable {
    let date: Date
    let temp: Int
    let iconID: String
}

extension Array where Element == HourForecast {
    static func converted(_ model: ForecastResponse) -> [Element] {
        model.hourly.map { HourForecast(
            date: $0.dt.transformToDate(model.timezoneOffset),
            temp: Int($0.temp),
            iconID: $0.weather.first?.icon ?? ""
        ) }
    }
}

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
        self.cityEn = try container.decode(String.self, forKey: .cityEn)
        self.countryRu = try container.decode(String.self, forKey: .countryRu)
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
        
        guard
            let lat = Double(coordinate.lat),
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
