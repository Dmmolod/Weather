//
//  ZoomingAnimateLifeCycle.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 03.03.2023.
//

import UIKit

protocol ZoomingAnimateLifeCycle {
    func preTransitionStateWillSet(for operation: UINavigationController.Operation)
    func animationComplete(for operatin: UINavigationController.Operation)
}
