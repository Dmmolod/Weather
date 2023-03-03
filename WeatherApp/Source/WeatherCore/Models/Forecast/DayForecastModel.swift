//
//  DayForecastModel.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 03.03.2023.
//

import Foundation

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
