//
//  Request.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 01.03.2023.
//

import Foundation

struct Request {
    let method: String
    let path: String
    let query: [String: String]
}

extension Request {
    
    static func get(
        _ path: String,
        query: [String: String] = [:]
    ) -> Request{
        Request(
            method: "GET",
            path: path,
            query: query
        )
    }
    
}
