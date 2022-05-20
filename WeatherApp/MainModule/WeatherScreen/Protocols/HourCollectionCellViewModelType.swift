import Foundation
import UIKit

protocol HourCollectionCellViewModelType {
    
    var time: Bindable<String> { get }
    var icon: Bindable<UIImage?> { get }
    var temperature: Bindable<String> { get }
}
