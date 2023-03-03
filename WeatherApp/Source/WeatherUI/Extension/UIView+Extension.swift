import UIKit

extension UIView {
    
    func addBlureEffect(style: UIBlurEffect.Style, alpha: CGFloat = 0.5) {
        
        let blure = UIVisualEffectView(effect: UIBlurEffect(style: style))
        blure.alpha = alpha
        self.addSubview(blure)
        blure.anchor(
            top: topAnchor,
            bottom: bottomAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor
        )
    }
}
