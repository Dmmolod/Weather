import UIKit

final class MoreInfoTableCell: UITableViewCell {
    
    private var viewModel: MoreInfoCellViewModel?
    
    private var collectionHeightAnchor: NSLayoutConstraint?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.register(MoreInfoCollectionCell.self, forCellWithReuseIdentifier: MoreInfoCollectionCell.identifier)
        
        return collectionView
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        updateCollectionViewHeight(from: contentView.frame.width)
    }
    
    func configure(model: MoreInfoCellViewModel) {
        self.reloadWith(model)
    }
    
    private func reloadWith(_ model: MoreInfoCellViewModel) {
        self.viewModel = model
        collectionView.reloadData()
    }
    
    private func setupUI() {
        contentView.addSubview(collectionView)
        collectionView.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            trailing: contentView.trailingAnchor
        )
        
        collectionHeightAnchor = collectionView.heightAnchor.constraint(equalToConstant: 1)
        collectionHeightAnchor?.isActive = true
        
        let collectionBottomAnchor = collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        collectionBottomAnchor.priority = .init(rawValue: 999)
        collectionBottomAnchor.isActive = true
    }
    
    private func updateCollectionViewHeight(from collectionWidth: Double) {
        let itemCount = MoreInfoItemType.allCases.count
        let rowsCount = itemCount % 2 == 0 ? itemCount/2 : (itemCount + 1) / 2
        let bottomOffset = rowsCount*5
        let newHeight = Double((Int(collectionWidth)/2 - 5) * rowsCount + bottomOffset)
        
        self.collectionHeightAnchor?.constant = newHeight
    }
}

extension MoreInfoTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.infoCells.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let currentForecast = viewModel?.currentForecast,
            let cellModel = viewModel?.infoCells[safe: indexPath.item],
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MoreInfoCollectionCell.identifier,
                for: indexPath
            ) as? MoreInfoCollectionCell
        else { return UICollectionViewCell() }
        
        cell.layer.cornerRadius = layer.cornerRadius
        cell.configure(
            model: cellModel,
            currentForecast: currentForecast
        )
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = Double(collectionView.frame.size.width)
        let side = collectionWidth/2 - 5
        
        return CGSize(width: side, height: side)
    }
}
