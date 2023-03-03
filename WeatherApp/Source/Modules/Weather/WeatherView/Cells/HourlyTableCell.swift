import UIKit

final class HourlyTableCell: UITableViewCell {
    private let hourlyForecastCollection: UICollectionView
    private var items: [HourCollectionCellViewModel] = []
    
    func configure(_ items: [HourCollectionCellViewModel]) {
        reload(with: items)
    }
    
    private func reload(with items: [HourCollectionCellViewModel]) {
        self.items = items
        hourlyForecastCollection.reloadData()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constans.minimumLineSpacingInset
        layout.scrollDirection = .horizontal
        self.hourlyForecastCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addBlureEffect(style: .light)
        setupCollection()
    }
    
    required init?(coder: NSCoder) {
        self.hourlyForecastCollection = UICollectionView(frame: .zero, collectionViewLayout: .init())
        super.init(coder: coder)
    }
    
    private func setupCollection() {
        hourlyForecastCollection.contentInset = UIEdgeInsets(
            top: Constans.topInset,
            left: Constans.leftInset,
            bottom: Constans.bottomInset,
            right: Constans.rightInset
        )
        hourlyForecastCollection.delegate = self
        hourlyForecastCollection.dataSource = self
        hourlyForecastCollection.register(HourCollectionCell.self, forCellWithReuseIdentifier: HourCollectionCell.identifier)
        hourlyForecastCollection.backgroundColor = backgroundColor
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        contentView.addSubview(hourlyForecastCollection)
        
        hourlyForecastCollection.anchor(
            top: contentView.topAnchor,
            bottom: contentView.bottomAnchor,
            leading: contentView.leadingAnchor,
            trailing: contentView.trailingAnchor
        )
    }
}

extension HourlyTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let model = items[safe: indexPath.item] else { return UICollectionViewCell() }
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HourCollectionCell.identifier,
            for: indexPath
        )
        
        (cell as? HourCollectionCell)?.configure(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = Constans.hourlyForecastItemWidth(in: collectionView, itemsToShowCount: 5)
        let height = collectionView.frame.height - Constans.topInset - Constans.bottomInset
        return CGSize(width: width, height: height)
    }
    
}
