import Foundation
import UIKit

class AnimationIntoCell: NSObject, UIViewControllerAnimatedTransitioning {
    
    let toVC: AnimatableTransitionFromTableCell
    let animateCellIndexPath: IndexPath
    
    init(toVC: AnimatableTransitionFromTableCell, animateCellIndexPath: IndexPath) {
        self.toVC = toVC
        self.animateCellIndexPath = animateCellIndexPath
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionContext.containerView.addSubview(toVC.view)
        let cellSuperview = toVC.getTable()
        
        guard let fromVC = transitionContext.view(forKey: UITransitionContextViewKey.from),
              let animatedCell = toVC.getAnimateCell(from: animateCellIndexPath) else {
            transitionContext.completeTransition(false)
            return
        }
        
                
        let finishCellFrame = animatedCell.frame
        let offset = cellSuperview.contentOffset

        let container = UIView()
        container.addSubview(fromVC)
        
        transitionContext.containerView.addSubview(container)
        transitionContext.containerView.addSubview(animatedCell)
        
        container.frame = transitionContext.containerView.frame
        container.layer.cornerRadius = 20
        container.clipsToBounds = true
        
        let cellFrameFromSuperview = animatedCell.frame.offsetBy(dx: cellSuperview.frame.origin.x,
                                                          dy: cellSuperview.frame.origin.y - offset.y)

        (animatedCell.contentView.layer.sublayers?.first as? CAGradientLayer)?.frame = transitionContext.containerView.bounds
        animatedCell.frame = transitionContext.containerView.frame
        animatedCell.alpha = 0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0) {
            container.frame = cellFrameFromSuperview
            fromVC.frame.origin = CGPoint(x: -container.frame.origin.x, y: -container.frame.origin.y)
            animatedCell.frame = cellFrameFromSuperview
            animatedCell.alpha = 1
            container.alpha = 0
            
        } completion: { _ in
            (animatedCell.contentView.layer.sublayers?.first as? CAGradientLayer)?.frame = animatedCell.contentView.bounds
            container.removeFromSuperview()
            cellSuperview.addSubview(animatedCell)
            animatedCell.frame = finishCellFrame
            transitionContext.completeTransition(true)
        }
    }
}

class AnimationFromCell: NSObject, UIViewControllerAnimatedTransitioning {
    
    let fromVC: AnimatableTransitionFromTableCell
    let animateCellIndexPath: IndexPath
    
    init(fromVC: AnimatableTransitionFromTableCell, animateCellIndexPath: IndexPath) {
        self.fromVC = fromVC
        self.animateCellIndexPath = animateCellIndexPath
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.view(forKey: UITransitionContextViewKey.to),
              let animatedCell = fromVC.getAnimateCell(from: animateCellIndexPath) else { return }
        let cellSuperview = fromVC.getTable()
        
        let offset = cellSuperview.contentOffset
        let cellStartFrame = animatedCell.frame
        
        let container = UIView(frame: animatedCell.frame.offsetBy(dx: cellSuperview.frame.origin.x, dy: cellSuperview.frame.origin.y - offset.y))
        container.addSubview(toVC)
        
        transitionContext.containerView.addSubview(fromVC.view)
        transitionContext.containerView.addSubview(container)
        
        
        toVC.frame.origin = CGPoint(x: -container.frame.origin.x, y: -container.frame.origin.y)
        toVC.frame.size = transitionContext.containerView.frame.size

        container.layer.cornerRadius = 20
        container.clipsToBounds = true
        container.alpha = 0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0) {
            container.frame = transitionContext.containerView.frame
            cellSuperview.bringSubviewToFront(animatedCell)
            animatedCell.frame = transitionContext.containerView.frame.offsetBy(dx: -cellSuperview.frame.origin.x, dy: -cellSuperview.frame.origin.y + offset.y)
            animatedCell.alpha = 0
            container.alpha = 1
            toVC.frame = transitionContext.containerView.frame
        } completion: { _ in
            container.removeFromSuperview()
            animatedCell.frame = cellStartFrame
            transitionContext.containerView.addSubview(toVC)
            transitionContext.completeTransition(true)
        }
    }
}
