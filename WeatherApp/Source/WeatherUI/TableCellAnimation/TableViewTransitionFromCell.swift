import UIKit

protocol TableViewCellTransitionable: UIViewController {
    func zoomingCell() -> UITableViewCell?
}

struct TableViewTransitionFromCell: AnimateTransitionable {
    
    let transitionDuration: CGFloat
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        do {
            let (containerView, fromView, toView, zoomingCell) = try fetchTransitionObjects(for: transitionContext)
            self.animateTransitionFromCell(
                duration: transitionDuration,
                containerView: containerView,
                fromView: fromView,
                toView: toView,
                zoomingCell: zoomingCell) {
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
        } catch {
            print(error)
            transitionContext.completeTransition(false)
        }
    }
    
    private func fetchTransitionObjects(for transitionContext: UIViewControllerContextTransitioning) throws -> (
        containerView: UIView,
        fromView: UIView,
        toView: UIView,
        zoomingCell: UIView
    ) {
        let containerView = transitionContext.containerView
        let fromVC = transitionContext.viewController(forKey: .from) as? TableViewCellTransitionable
        let toVC = transitionContext.viewController(forKey: .to)
        let toView = toVC?.view
        
        guard let toView else { throw NSError(domain: "Cannot get object: \"toView\"", code: 0) }
        
        guard let fromView = fromVC?.view else { throw NSError(domain: "Cannot get object: \"fromView", code: 1) }
        guard let zoomingCell = fromVC?.zoomingCell() else { throw NSError(domain: "Cannot get object: \"zoomingCell\"", code: 2) }
        
        return (containerView, fromView, toView, zoomingCell)
    }
    
    private func animateTransitionFromCell(
        duration: TimeInterval,
        containerView: UIView,
        fromView: UIView,
        toView: UIView,
        zoomingCell: UIView,
        completion: @escaping () -> ()
    ) {
        let cellStartFrame = zoomingCell.frame
        let toViewContainer = UIView()
        
        preTransitionLayout(
            containerView: containerView,
            zoomingCell: zoomingCell,
            fromView: fromView,
            toView: toView,
            toViewContainer: toViewContainer
        )
        
        UIView.animate(withDuration: duration, delay: 0) {
            self.postTransitionLayout(
                containerView: containerView,
                zoomingCell: zoomingCell,
                toViewContainer: toViewContainer,
                toView: toView
            )
            zoomingCell.layoutIfNeeded()
        } completion: { _ in
            toViewContainer.removeFromSuperview()
            containerView.addSubview(toView)
            zoomingCell.frame = cellStartFrame
            (zoomingCell as? ZoomingAnimateLifeCycle)?.animationComplete(for: .push)
            
            completion()
        }
    }
    
    private func preTransitionLayout(
        containerView: UIView,
        zoomingCell: UIView,
        fromView: UIView,
        toView: UIView,
        toViewContainer: UIView
    ) {
        (zoomingCell as? ZoomingAnimateLifeCycle)?.preTransitionStateWillSet(for: .push)
        let cellConvertedFrame = zoomingCell.superview?.convert(
            zoomingCell.frame,
            to: containerView
        ) ?? .zero
        
        toViewContainer.frame = cellConvertedFrame
        
        containerView.addSubview(fromView)
        containerView.addSubview(toViewContainer)
        toViewContainer.addSubview(toView)
        
        toView.frame = CGRect(
            origin: containerView.convert(
                toView.frame.origin,
                to: toView
            ),
            size: containerView.bounds.size
        )
        
        toViewContainer.layer.cornerRadius = zoomingCell.layer.cornerRadius
        toViewContainer.clipsToBounds = true
        toViewContainer.alpha = 0
    }
    
    private func postTransitionLayout(
        containerView: UIView,
        zoomingCell: UIView,
        toViewContainer: UIView,
        toView: UIView
    ) {
        zoomingCell.superview?.bringSubviewToFront(zoomingCell)
        
        toViewContainer.frame = containerView.frame
        toViewContainer.alpha = 1

        zoomingCell.alpha = 0
        zoomingCell.frame = CGRect(
            origin: containerView.convert(
                zoomingCell.frame.origin,
                to: zoomingCell
            ),
            size: containerView.bounds.size
        )
        
        toView.frame = toViewContainer.frame
    }
}
