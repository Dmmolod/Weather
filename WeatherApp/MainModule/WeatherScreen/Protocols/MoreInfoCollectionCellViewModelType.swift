import Foundation
import UIKit

protocol MoreInfoCollectionCellViewModelType {
    
    var image: Bindable<UIImage?> { get }
    var infoTitle: Bindable<String> { get }
    var infoText: Bindable<String> { get }
    var description: Bindable<String?> { get }
}
