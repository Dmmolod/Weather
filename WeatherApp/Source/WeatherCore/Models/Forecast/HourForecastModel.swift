//
//  HourForecastModel.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 03.03.2023.
//

import Foundation

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
