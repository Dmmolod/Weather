import Foundation
import UIKit

protocol Coordinator {
    var window: UIWindow? { get }
    var navController: UINavigationController? { get set }
}
