//
//  RoutingLogic.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 07.12.2022.
//

import UIKit

protocol RoutingLogic: AnyObject {
    func push(
        _ coordinator: BaseCoordinator,
        animated: Bool
    )
    func push(
        _ module: UIViewController,
        animated: Bool
    )
    func present(
        _ coordinator: BaseCoordinator,
        animated: Bool
    )
    func pop(animated: Bool)
    func popToRoot(animated: Bool)
    func present(
        _ module: UIViewController,
        animated: Bool
    )
    func dismiss(animated: Bool, completion: (() -> Void)?)
}
