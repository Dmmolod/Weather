//
//  Collection+Additions.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 08.12.2022.
//

extension Collection {
    
    subscript (safe index: Index) -> Element? {
        endIndex >= index ? self[index] : nil
    }
}
