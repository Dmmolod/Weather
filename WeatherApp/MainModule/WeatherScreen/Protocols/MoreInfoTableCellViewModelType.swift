import Foundation

protocol MoreInfoTableCellViewModelType {
    
    func numberOfItemsInSection() -> Int
    func moreInfoCollectionCellViewModel(at indexPath: IndexPath) -> MoreInfoCollectionCellViewModelType?
    func itemSize(from collectionWidth: Double) -> Double
    func collectionViewHeight(from collectionWidth: Double) -> Double
}
