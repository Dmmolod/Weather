//
//  TableViewTransitionToCell.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 28.02.2023.
//

import UIKit

struct TableViewTransitionToCell: AnimateTransitionable {
    
    private typealias TransitionObjects = (
        containerView: UIView,
        fromView: UIView,
        fromViewContainer: UIView,
        toView: UIView,
        zoomingCell: UIView
    )
    
    let transitionDuration: CGFloat
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        fetchTransitionObjects(for: transitionContext) { result in
            switch result {
            case let .success(transitionObjects):
                self.animateTransitionIntoCell(with: transitionObjects) {
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            case let .failure(failure):
                print(failure)
                transitionContext.completeTransition(false)
            }
        }
    }
    
    private func fetchTransitionObjects(
        for transitionContext: UIViewControllerContextTransitioning,
        completion: @escaping (Result<TransitionObjects, Error>) -> ()
    ) {
        let containerView = transitionContext.containerView
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to) as? TableViewCellTransitionable
        let toView = toVC?.view
        let fromViewContainer = UIView()
        
        guard let toView else { return completion(.failure(NSError(domain: "Cannot get object: \"toView\"", code: 0))) }
        
        guard let fromView = fromVC?.view else { return completion(.failure(NSError(domain: "Cannot get object: \"fromView", code: 1))) }
        
        toView.isHidden = true
        containerView.addSubview(toView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
            guard let zoomingCell = toVC?.zoomingCell() else {
                completion(.failure(NSError(domain: "Cannot get object: \"zoomingCell\"", code: 2)))
                return
            }
            return completion(.success((containerView, fromView, fromViewContainer, toView, zoomingCell)))
        }
    }
    
    private func animateTransitionIntoCell(
        with transitionObjects: TransitionObjects,
        completion: @escaping () -> ()
    ) {
        let (containerView, _, fromViewContainer, _, zoomingCell) = transitionObjects
        (zoomingCell as? ZoomingAnimateLifeCycle)?.preTransitionStateWillSet(for: .pop)
        
        let finishZoomingCellFrame = zoomingCell.frame
        let convertedZoomingCellFrame = zoomingCell.superview?.convert(
            zoomingCell.frame,
            to: containerView
        ) ?? .zero
        
        preTransitionLayout(for: transitionObjects)
        
        UIView.animate(withDuration: transitionDuration, delay: 0) {
            self.postTransitionLayout(
                for: transitionObjects,
                convertedZoomingCellFrame: convertedZoomingCellFrame,
                finishZoomingCellFrame: finishZoomingCellFrame
            )
            zoomingCell.layoutIfNeeded()
        } completion: { _ in
            fromViewContainer.removeFromSuperview()
            (zoomingCell as? ZoomingAnimateLifeCycle)?.animationComplete(for: .pop)
            completion()
        }
    }
    
    private func preTransitionLayout(for transitionObjects: TransitionObjects) {
        let (containerView, fromView, fromViewContainer, toView, zoomingCell) = transitionObjects
        fromViewContainer.addSubview(fromView)
        containerView.addSubview(fromViewContainer)
        
        fromViewContainer.frame = containerView.frame
        fromViewContainer.layer.cornerRadius = zoomingCell.layer.cornerRadius
        fromViewContainer.clipsToBounds = true
        
        zoomingCell.frame.origin = containerView.convert(
            zoomingCell.frame.origin,
            to: zoomingCell
        )
        zoomingCell.frame.size = containerView.bounds.size
        zoomingCell.alpha = 0
        
        zoomingCell.layoutIfNeeded()
        toView.isHidden = false
    }
    
    private func postTransitionLayout(
        for transitionObjects: TransitionObjects,
        convertedZoomingCellFrame: CGRect,
        finishZoomingCellFrame: CGRect
    ) {
        let (_, fromView, fromViewContainer, _, zoomingCell) = transitionObjects
        fromViewContainer.frame = convertedZoomingCellFrame
        fromViewContainer.alpha = 0
        
        fromView.frame.origin = CGPoint(
            x: -fromViewContainer.frame.origin.x,
            y: -fromViewContainer.frame.origin.y
        )
        
        zoomingCell.frame = finishZoomingCellFrame
        zoomingCell.alpha = 1
    }
}
