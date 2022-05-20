import Foundation
import UIKit
protocol DailyTableCellViewModelType {
    
    var dayIcon: Bindable<UIImage?> { get }
    var day: Bindable<String> { get }
    var temp_min: Bindable<String> { get }
    var temp_max: Bindable<String> { get }
}
