import Foundation

class MoreInfoTableCellViewModel: MoreInfoTableCellViewModelType {
    
    private let currentForecast: CurrentForescast
    
    init(_ currentForecast: CurrentForescast) {
        self.currentForecast = currentForecast
    }
    
    func numberOfItemsInSection() -> Int {
        MoreInfoItemsType.allCases.count
    }
    
    func moreInfoCollectionCellViewModel(at indexPath: IndexPath) -> MoreInfoCollectionCellViewModelType? {
        guard indexPath.item < MoreInfoItemsType.allCases.count else { return nil }
        let itemtype = MoreInfoItemsType.allCases[indexPath.item]
        return MoreInfoCollectionCellViewModel(currentForecast, itemType: itemtype)
    }
    
    func itemSize(from collectionWidth: Double) -> Double {
        collectionWidth/2 - 5
    }
    
    func collectionViewHeight(from collectionWidth: Double) -> Double {
        let itemCount = MoreInfoItemsType.allCases.count
        let rowsCount = itemCount % 2 == 0 ? itemCount/2 : (itemCount + 1) / 2
        let bottomOffset = rowsCount*5
        return Double((Int(collectionWidth)/2 - 5) * rowsCount + bottomOffset)
    }
    
}
