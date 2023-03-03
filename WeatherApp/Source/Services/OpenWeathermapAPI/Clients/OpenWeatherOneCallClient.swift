//
//  OpenWeatherOneCallClient.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 01.03.2023.
//

import UIKit

protocol OneCallApiClientProtocol {
    func fetchForcast(
        lat: String,
        lon: String,
        completion: @escaping (Result<ForecastResponse, Error>) -> ()
    )
}

struct OneCallApiClient {
    
    private let api: ApiClient
    
    init(api: ApiClient = ApiClient()) {
        self.api = api
    }
}

extension OneCallApiClient: OneCallApiClientProtocol {
    
    func fetchForcast(
        lat: String,
        lon: String,
        completion: @escaping (Result<ForecastResponse, Error>) -> ()
    ) {
        let query = [
            "lat": lat,
            "lon" : lon,
            "lang" : "en".localized,
            "exclude": "minutely,alerts",
            "units" : "metric"
        ]
        
        let request: Request = .get("/data/2.5/onecall", query: query)
        
        api.request(request, response: completion)
    }
    
}
