//
//  MockForecastModel.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 21.02.2023.
//

import Foundation

let mockForecast = Forecast(
    cityName: "TEST",
    cityInfo: CityInfo(
        countryEn: "Test en",
        countryRu: "Test ru",
        cityEn: "Test en",
        cityRu: "Test ru",
        coordinate: CityInfo.Coordinate(
            lat: "100",
            lon: "1"
        )
    ),
    current: CurrentForescast(
        date: .now,
        temp: -99,
        humidity: -100,
        pressure: 99,
        feelsLike: 1000,
        windSpeed: 10000,
        iconID: "none",
        description: "LOL",
        weatherState: "LOL"
    ),
    hourly: [
        HourForecast(
            date: .now,
            temp: 198,
            iconID: "none"
        )
    ],
    daily: [
        DayForecast(
            date: .now,
            tempMax: 100,
            tempMin: 2,
            iconID: "none"
        )
    ]
)
