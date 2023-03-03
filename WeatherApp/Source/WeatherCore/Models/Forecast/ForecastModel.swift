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


