import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var rootViewController: UIViewController? { get set }
    var navigationController: UINavigationController? { get set }
    func start()
}
