import Foundation
import UIKit

struct Constans {
    
    // MARK: Global
    static let leftInset: CGFloat = 20
    static let rightInset: CGFloat = 20
    static let topInset: CGFloat = 20
    static let bottomInset: CGFloat = 20
    
    // MARK: Collection view
    static let minimumLineSpacingInset: CGFloat = 20
    
    static func hourlyForecastItemWidth(in view: UIView, itemsToShowCount: CGFloat ) -> CGFloat {
        (view.bounds.width - rightInset - leftInset - (minimumLineSpacingInset/itemsToShowCount)) / itemsToShowCount
    }
    
    // MARK: Weather info Table view
    static let hourlyCellHeight: CGFloat = 200
    static let dayliCellHeight: CGFloat = 50
    static let moreInfoCellHeight: CGFloat = 200
    
    // MARK: Favourites Table View
    static let favouriteCityCellHeight: CGFloat = 150
    static let defaultTableHeight: CGFloat = 44
    static let maxResultCount: Int = 20
    
}
