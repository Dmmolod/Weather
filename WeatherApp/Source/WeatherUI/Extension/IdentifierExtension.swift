//
//  IdentifierExtensions.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 03.03.2023.
//

import UIKit

extension UITableViewCell {
    static var identifier: String { String(describing: Self.self) }
}

extension UICollectionViewCell {
    static var identifier: String { String(describing: Self.self) }
}
