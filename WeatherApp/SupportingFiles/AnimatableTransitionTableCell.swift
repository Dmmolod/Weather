import Foundation
import UIKit

protocol AnimatableTransitionFromTableCell: UIViewController {
    func getTable() -> UITableView
    func getAnimateCell(from indexPath: IndexPath) -> UITableViewCell?
    func getIndexPath() -> IndexPath?
}

protocol AnimatableTransitionIntoTableCell: UIViewController {
    func getIndexPath() -> IndexPath?
}
