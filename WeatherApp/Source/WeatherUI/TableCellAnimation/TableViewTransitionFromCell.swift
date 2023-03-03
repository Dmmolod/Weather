import UIKit

protocol TableViewCellTransitionable: UIViewController {
    func zoomingCell() -> UITableViewCell?
}

struct TableViewTransitionFromCell: AnimateTransitionable {
    
    private typealias TransitionObjects = (
        containerView: UIView,
        fromView: UIView,
        toView: UIView,
        toViewContainer: UIView,
        zoomingCell: UIView
    )
    
    let transitionDuration: CGFloat
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        do {
            let transitionObjects = try fetchTransitionObjects(for: transitionContext)
            self.animateTransitionFromCell(
                for: transitionObjects,
                completion: {
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            )
        } catch {
            print(error)
            transitionContext.completeTransition(false)
        }
    }
    
    private func fetchTransitionObjects(for transitionContext: UIViewControllerContextTransitioning) throws -> TransitionObjects {
        let containerView = transitionContext.containerView
        let fromVC = transitionContext.viewController(forKey: .from) as? TableViewCellTransitionable
        let toVC = transitionContext.viewController(forKey: .to)
        let toView = toVC?.view
        let toViewContainer = UIView()
        
        guard let toView else { throw NSError(domain: "Cannot get object: \"toView\"", code: 0) }
        
        guard let fromView = fromVC?.view else { throw NSError(domain: "Cannot get object: \"fromView", code: 1) }
        guard let zoomingCell = fromVC?.zoomingCell() else { throw NSError(domain: "Cannot get object: \"zoomingCell\"", code: 2) }
        
        return (containerView, fromView, toView, toViewContainer, zoomingCell)
    }
    
    private func animateTransitionFromCell(
        for transitionObjects: TransitionObjects,
        completion: @escaping () -> ()
    ) {
        let (containerView, _, toView,  toViewContainer, zoomingCell) = transitionObjects
        
        let cellStartFrame = zoomingCell.frame
        
        preTransitionLayout(for: transitionObjects)
        
        UIView.animate(withDuration: transitionDuration) {
            self.postTransitionLayout(for: transitionObjects)
            zoomingCell.layoutIfNeeded()
        } completion: { _ in
            toViewContainer.removeFromSuperview()
            containerView.addSubview(toView)
            zoomingCell.frame = cellStartFrame
            (zoomingCell as? ZoomingAnimateLifeCycle)?.animationComplete(for: .push)
            
            completion()
        }
    }
    
    private func preTransitionLayout(for transitionObjects: TransitionObjects) {
        let (containerView, fromView, toView, toViewContainer, zoomingCell) = transitionObjects
        
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
    
    private func postTransitionLayout(for transitionObjects: TransitionObjects) {
        let (containerView, _, toView, toViewContainer, zoomingCell) = transitionObjects
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
