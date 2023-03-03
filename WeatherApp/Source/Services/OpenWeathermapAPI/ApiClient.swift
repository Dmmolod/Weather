//
//  ApiClient.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 01.03.2023.
//

import Foundation


struct ApiClient {
    private let apiKey: String?
    private let apiKeyQuery: String
    let host: String
    
    init(
        apiKey: String? = "1916b1864fdbb31e8af1c91944e2b814",
        apiKeyQuery: String = "appid",
        host: String = "api.openweathermap.org"
    ) {
        self.apiKey = apiKey
        self.apiKeyQuery = apiKeyQuery
        self.host = host
    }
}

extension ApiClient {
    
    func request<Response: Decodable>(
        _ request: Request,
        response: @escaping (Result<Response, Error>) -> ()
    ) {
        let result = makeURLRequest(for: request)
        switch result {
        case let .success(request): send(request, response)
        case let .failure(error): response(.failure(error))
        }
    }
    
    func send<T: Decodable>(
        _ request: URLRequest,
        _ completion: @escaping (Result<T, Error>) -> ()
    ) {
        URLSession.shared.dataTask(
            with: request,
            completionHandler: { data, _, error in
                DispatchQueue.main.async {
                    if let error {
                        self.completionWithError(request: request, error, completion: completion)
                        return
                    }
                    
                    guard let data
                    else {
                        let error = NSError(domain: "cannot fetch dat", code: 3)
                        self.completionWithError(request: request, error, completion: completion)
                        return
                    }
                    
                    if let data = (data as? T) { return completion(.success(data)) }
                    
                    guard let response = try? JSONDecoder().decode(T.self, from: data)
                    else {
                        let error = NSError(domain: "Failed decode", code: 4)
                        self.completionWithError(request: request, error, completion: completion)
                        return
                    }
                    
                    completion(.success(response))
                }
            }
        ).resume()
    }
    
    private func completionWithError<Response: Decodable>(
        request: URLRequest,
        _ error: Error,
        completion: @escaping (Result<Response, Error>) -> ()
    ) {
        print(request)
        completion(.failure(error))
    }
    
    func makeURLRequest(for request: Request) -> Result<URLRequest, Error> {
        makeURL(path: request.path, query: request.query).flatMap {
            makeRequest(url: $0, method: request.method)
        }
    }
    
    func makeURL(path: String, query: [String: String]) -> Result<URL, Error> {
        var query = query
        
        if let apiKey {
            query.updateValue(apiKey, forKey: apiKeyQuery)
        }
        
        let correctPath = path.starts(with: "/") ? path : "/\(path)"
        
        guard let url = URL(string: correctPath) else { return .failure(NSError(domain: "", code: 0)) }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.scheme = "https"
        components?.host = host
        
        if !query.isEmpty {
            components?.queryItems = query.map(URLQueryItem.init)
        }
        
        guard let url = components?.url else { return .failure(NSError(domain: "", code: 1)) }
        
        return .success(url)
    }
    
    func makeRequest(url: URL, method: String) -> Result<URLRequest, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        return .success(request)
    }
}
