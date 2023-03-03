import UIKit

final class MoreInfoCollectionCell: UICollectionViewCell {
    
    private let infoImage = UIImageView()
    
    private let titleCell: UILabel = {
       let lable = UILabel()
        lable.textAlignment = .left
        lable.textColor = .black
        lable.font = .systemFont(ofSize: 14, weight: .light)
        return lable
    }()
    private let descriptionCell: UILabel = {
       let lable = UILabel()
        lable.textAlignment = .center
        lable.textColor = .black
        lable.numberOfLines = 0
        lable.font = .italicSystemFont(ofSize: 30)
        return lable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { nil }
    
    func configure(model: MoreInfoItemType, currentForecast: CurrentForescast) {
        infoImage.image = model.info.icon
        titleCell.text = model.info.titleText
        descriptionCell.text = model.descriptionText(for: currentForecast)
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.addBlureEffect(style: .light)
        backgroundColor = .clear
        [infoImage, descriptionCell, titleCell].forEach({ contentView.addSubview($0) })
        
        titleCell.textColor = .white
        descriptionCell.textColor = .white
        
        infoImage.contentMode = .scaleAspectFit
        infoImage.anchor(
            top: contentView.topAnchor,
            bottom: titleCell.bottomAnchor,
            leading: contentView.leadingAnchor,
            paddingTop: 10,
            paddingLeading: 10,
            width: 20, height: 20
        )
        
        titleCell.anchor(
            top: infoImage.topAnchor,
            leading: infoImage.trailingAnchor,
            trailing: contentView.trailingAnchor,
            paddingLeading: 5
        )
        
        descriptionCell.anchor(
            top: titleCell.bottomAnchor,
            bottom: contentView.bottomAnchor,
            leading: contentView.leadingAnchor,
            trailing: titleCell.trailingAnchor,
            paddingTop: 20, paddingBottom: 20
        )
    }
}
