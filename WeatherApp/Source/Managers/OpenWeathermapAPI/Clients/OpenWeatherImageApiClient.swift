//
//  OpenWeatherImageLoader.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 01.03.2023.
//

import UIKit

struct OpenWeatherImageLoader: ImageLoadable {
    
    enum FetchError: LocalizedError {
        case wrongUrl
        case error(value: Error)
        case unknown
        
        init(error: Error?) {
            if let error { self = .error(value: error) }
            else { self = .unknown }
        }
        
        var errorDescription: String? {
            switch self {
            case let .error(value): return value.localizedDescription
            case .wrongUrl: return "wrong url (or image id)"
            case .unknown: return "failed to fetch image, unknown error"
            }
        }
    }
    
    private let schema = "https://"
    private let host = "openweathermap.org"
    private let path = "/img/wn/"
    
    func fetchImageWith(
        id: String,
        completion: @escaping (Result<UIImage?, Error>) -> ()
    ) {
        guard let url = URL(string: schema + host + path + "\(id)@2x.png")
        else { return completion(.failure(FetchError.wrongUrl)) }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                guard
                    let data = data,
                    let image = UIImage(data: data)
                else {
                    let fetchError = FetchError(error: error)
                    return completion(.failure(fetchError))
                }
                
                completion(.success(image))
            }
        }.resume()
    }
}
