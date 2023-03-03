//
//  ForecastLoadModel.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 26.01.2023.
//

enum ForecastLoadModel {
    case forecast(_ mode: Forecast)
    case cityInfo(_ cityInfo: CityInfo)
}
