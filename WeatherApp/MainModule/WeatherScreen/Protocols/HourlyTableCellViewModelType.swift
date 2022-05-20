import Foundation

protocol HourlyTableCellViewModelType {
        
    func numberOfItemsInSection(_ section: Int) -> Int?
    func hourCollectionCellViewModelType(for indexPath: IndexPath) -> HourCollectionCellViewModelType?
}
