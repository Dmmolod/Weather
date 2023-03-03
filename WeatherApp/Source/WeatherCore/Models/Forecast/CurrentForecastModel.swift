//
//  CurrentForecastModel.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 03.03.2023.
//

import Foundation

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
