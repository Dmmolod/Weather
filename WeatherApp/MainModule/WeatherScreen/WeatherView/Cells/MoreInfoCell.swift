import Foundation
import UIKit

class MoreInfoCell: UITableViewCell {
    
    static let identifier = "MoreInfoCell"
    
    var viewModel: MoreInfoTableCellViewModelType? {
        didSet {
            collectionView.reloadData()
        }
    }
    var collectionHeightAnchor: NSLayoutConstraint?
    private var collectionHeight: CGFloat = 0 {
        didSet {
            collectionHeightAnchor?.constant = collectionHeight
        }
    }
    
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
        guard let collectionHeight = viewModel?.collectionViewHeight(from: contentView.frame.width) else { return }
        
        self.collectionHeight = collectionHeight
    }
    
    private func setupUI() {
        contentView.addSubview(collectionView)
        collectionView.anchor(top: contentView.topAnchor,
                              leading: contentView.leadingAnchor,
                              trailing: contentView.trailingAnchor)
        
        collectionHeightAnchor = collectionView.heightAnchor.constraint(equalToConstant: 1)
        collectionHeightAnchor?.isActive = true
        
        let collectionBottomAnchor = collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        collectionBottomAnchor.priority = .init(rawValue: 999)
        collectionBottomAnchor.isActive = true
    }
    
}

extension MoreInfoCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.numberOfItemsInSection() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoreInfoCollectionCell.identifier,
                                                            for: indexPath) as? MoreInfoCollectionCell else { return UICollectionViewCell() }
        cell.layer.cornerRadius = layer.cornerRadius
        cell.viewModel = viewModel?.moreInfoCollectionCellViewModel(at: indexPath)
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = Double(collectionView.frame.size.width)
        let side = viewModel?.itemSize(from: collectionWidth) ?? 0
        
        return CGSize(width: side, height: side)
    }
}
