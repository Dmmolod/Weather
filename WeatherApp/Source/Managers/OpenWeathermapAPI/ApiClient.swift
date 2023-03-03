//
//  ApiClient.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 01.03.2023.
//

import Foundation


struct ApiClient {
    private let apiKey = "1916b1864fdbb31e8af1c91944e2b814"
    let host: String
    
    init(host: String = "api.openweathermap.org") {
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
                    if let error { return completion(.failure(error)) }
                    guard let data
                    else { return completion(.failure(NSError(domain: "", code: 3))) }
                    guard let response = try? JSONDecoder().decode(T.self, from: data)
                    else { return completion(.failure(NSError(domain: "", code: 4))) }
                    
                    completion(.success(response))
                }
            }
        ).resume()
    }
    
    func makeURLRequest(for request: Request) -> Result<URLRequest, Error> {
        makeURL(path: request.path, query: request.query).flatMap {
            makeRequest(url: $0, method: request.method)
        }
    }
    
    func makeURL(path: String, query: [String: String]) -> Result<URL, Error> {
        var query = query
        query.updateValue(apiKey, forKey: "appid")
        
        var correctPath = ""
        
        if !path.starts(with: "/") {
            correctPath = "/\(path)"
        } else { correctPath = path }
        
        guard let url = URL(string: correctPath) else { return .failure(NSError(domain: "", code: 0)) }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.scheme = "https"
        components?.host = host
        components?.queryItems = query.map(URLQueryItem.init)
        
        guard let url = components?.url else { return .failure(NSError(domain: "", code: 1)) }
        
        return .success(url)
    }
    
    func makeRequest(url: URL, method: String) -> Result<URLRequest, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        return .success(request)
    }
}
