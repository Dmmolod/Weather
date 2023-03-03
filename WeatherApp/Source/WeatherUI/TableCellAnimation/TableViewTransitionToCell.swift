//
//  TableViewTransitionToCell.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 28.02.2023.
//

import UIKit

struct TableViewTransitionToCell: AnimateTransitionable {
    
    let transitionDuration: CGFloat
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        fetchTransitionObjects(for: transitionContext) { result in
            switch result {
            case let .success(transitionObjects):
                let (containerView, fromView, toView, zoomingCell) = transitionObjects
                self.animateTransitionIntoCell(
                    duration: transitionDuration,
                    containerView: containerView,
                    fromView: fromView,
                    toView: toView,
                    zoomingCell: zoomingCell) {
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
        completion: @escaping (
            Result<(containerView: UIView, fromView: UIView, toView: UIView, zoomingCell: UIView), Error>
        ) -> ()
    ) {
        let containerView = transitionContext.containerView
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to) as? TableViewCellTransitionable
        let toView = toVC?.view
        
        guard let toView else { return completion(.failure(NSError(domain: "Cannot get object: \"toView\"", code: 0))) }
        
        guard let fromView = fromVC?.view else { return completion(.failure(NSError(domain: "Cannot get object: \"fromView", code: 1))) }
        
        /// this is important so as not to overload the table view until it has a window
        toView.isHidden = true
        containerView.addSubview(toView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
            guard let zoomingCell = toVC?.zoomingCell() else { return completion(.failure(NSError(domain: "Cannot get object: \"zoomingCell\"", code: 2))) }
            return completion(.success((containerView, fromView, toView, zoomingCell)))
        }
    }
    
    private func animateTransitionIntoCell(
        duration: TimeInterval,
        containerView: UIView,
        fromView: UIView,
        toView: UIView,
        zoomingCell: UIView,
        completion: @escaping () -> ()
    ) {
        (zoomingCell as? ZoomingAnimateLifeCycle)?.preTransitionStateWillSet(for: .pop)
        let finishZoomingCellFrame = zoomingCell.frame
        let convertedZoomingCellFrame = zoomingCell.superview?.convert(
            zoomingCell.frame,
            to: containerView
        ) ?? .zero
        
        let fromViewContainer = UIView()
        
        preTransitionLayout(
            containerView: containerView,
            zoomingCell: zoomingCell,
            fromView: fromView,
            toView: toView,
            fromViewContainer: fromViewContainer
        )
        
        UIView.animate(withDuration: duration, delay: 0) {
            self.postTransitionLayout(
                fromView: fromView,
                zoomingCell: zoomingCell,
                fromViewContainer: fromViewContainer,
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
    
    private func preTransitionLayout(
        containerView: UIView,
        zoomingCell: UIView,
        fromView: UIView,
        toView: UIView,
        fromViewContainer: UIView
    ) {
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
        fromView: UIView,
        zoomingCell: UIView,
        fromViewContainer: UIView,
        convertedZoomingCellFrame: CGRect,
        finishZoomingCellFrame: CGRect
    ) {
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
