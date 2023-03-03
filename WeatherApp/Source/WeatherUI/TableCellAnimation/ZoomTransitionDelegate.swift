//
//  ZoomTransitionDelegate.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 17.02.2023.
//

import UIKit

protocol AnimateTransitionable {
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
}

final class ZoomTransitioningDelegate: NSObject {
    var transitionDuration: CGFloat
    var transitionOperation: UINavigationController.Operation
    
    init(
        transitionDuration: CGFloat = 0.3,
        transitionOperation: UINavigationController.Operation
    ) {
        self.transitionDuration = transitionDuration
        self.transitionOperation = transitionOperation
    }
}

extension ZoomTransitioningDelegate: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        let transitionAnimation: AnimateTransitionable?
        
        switch transitionOperation {
        case .pop: transitionAnimation = TableViewTransitionToCell(transitionDuration: duration)
        case .push: transitionAnimation = TableViewTransitionFromCell(transitionDuration: duration)
        default: transitionAnimation = nil
        }
        
        guard let transitionAnimation else { return defaultTransition(using: transitionContext) }
        transitionAnimation.animateTransition(using: transitionContext)
    }
    
    private func defaultTransition(using context: UIViewControllerContextTransitioning) {
        if let toView = context.view(forKey: .to) {
            context.containerView.addSubview(toView)
            context.completeTransition(!context.transitionWasCancelled)
        } else { context.completeTransition(false) }
    }
}
