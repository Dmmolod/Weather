import UIKit

enum ResultTableViewModel {
    case search(items: [SearchCellViewModel])
    case favorites(items: [FavoriteCellViewModel])
    
    var info: (
        sectionsCount: Int,
        rowsCount: Int,
        cellIdentifier: String,
        editingStyle: UITableViewCell.EditingStyle
    ) {
        switch self {
        case let .search(items):
            return (
                1,
                items.count,
                SearchCell.identifier,
                .none
            )
        case let .favorites(items):
            return (
                items.count,
                1,
                FavoriteCityCell.identifier,
                .delete
            )
        }
    }
}
