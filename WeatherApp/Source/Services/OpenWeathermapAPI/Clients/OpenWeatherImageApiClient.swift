//
//  OpenWeatherImageLoader.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 01.03.2023.
//

import UIKit

struct OpenWeatherImageLoader {
    
    private let api: ApiClient
    
    init(api: ApiClient = ApiClient(host: "openweathermap.org")) {
        self.api = api
    }
    
}

extension OpenWeatherImageLoader: ImageLoadable {
    
    func fetchImageWith(
        id: String,
        completion: @escaping (Result<UIImage, Error>) -> ()
    ) {
        let request: Request = .get("/img/wn/\(id)@2x.png")
        
        api.request(request) { (result: Result<Data, Error>) in
            switch result {
            case let .success(data):
                if let image = UIImage(data: data) {
                    completion(.success(image))
                } else { completion(.failure(FetchError.failedFetchImage)) }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

extension OpenWeatherImageLoader {
    enum FetchError: LocalizedError {
        case failedFetchImage
        
        var errorDescription: String? {
            switch self {
            case .failedFetchImage: return "Failed to fetch the image"
            }
        }
    }
}
