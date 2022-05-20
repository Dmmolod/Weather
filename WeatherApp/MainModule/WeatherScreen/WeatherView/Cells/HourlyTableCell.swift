import UIKit

class HourlyTableCell: UITableViewCell {
    
    static let identifier = "NewHourlyForecastCell"
    private let hourlyForecastCollection: UICollectionView
    
    var viewModel: HourlyTableCellViewModelType? {
        didSet {
            hourlyForecastCollection.reloadData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constans.minimumLineSpacingInset
        layout.scrollDirection = .horizontal
        self.hourlyForecastCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.addBlureEffect(style: .light)
        setupCollection()
    }
    
    required init?(coder: NSCoder) {
        self.hourlyForecastCollection = UICollectionView(frame: .zero, collectionViewLayout: .init())
        super.init(coder: coder)
    }
    
    
    
    private func setupCollection() {
        hourlyForecastCollection.contentInset = UIEdgeInsets(top: Constans.topInset, left: Constans.leftInset, bottom: Constans.bottomInset, right: Constans.rightInset)
        hourlyForecastCollection.delegate = self
        hourlyForecastCollection.dataSource = self
        hourlyForecastCollection.register(HourCollectionCell.self, forCellWithReuseIdentifier: HourCollectionCell.identifier)
        
        backgroundColor = .clear
        hourlyForecastCollection.backgroundColor = backgroundColor
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        [contentView].forEach({
            $0.addSubview(hourlyForecastCollection)
            
            hourlyForecastCollection.anchor(top: $0.topAnchor,
                                            bottom: $0.bottomAnchor,
                                            leading: $0.leadingAnchor,
                                            trailing: $0.trailingAnchor)
        })
    }
}

extension HourlyTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItemsInSection(section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourCollectionCell.identifier,
                                                            for: indexPath) as? HourCollectionCell else { return UICollectionViewCell() }
        
        let hourCollectionCellViewModelType = viewModel?.hourCollectionCellViewModelType(for: indexPath)
        cell.viewModel = hourCollectionCellViewModelType
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = Constans.hourlyForecastItemWidth(in: collectionView, itemsToShowCount: 5)
        let height = collectionView.frame.height - Constans.topInset - Constans.bottomInset
        return CGSize(width: width, height: height)
    }
    
}
