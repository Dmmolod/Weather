import Foundation
import UIKit

class MoreInfoCollectionCell: UICollectionViewCell {
    
    static let identifier = "CustomCollectionCell"
    
    var viewModel: MoreInfoCollectionCellViewModelType? {
        didSet {
            bind()
        }
    }
    
    private let infoImage = UIImageView()
    
    private let titleCell: UILabel = {
       let lable = UILabel()
        lable.textAlignment = .left
        lable.textColor = .black
        lable.font = .systemFont(ofSize: 14, weight: .light)
        return lable
    }()
    private let infoCell: UILabel = {
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
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.addBlureEffect(style: .light)
        backgroundColor = .clear
        [infoImage, infoCell, titleCell].forEach({ contentView.addSubview($0) })
        
        titleCell.textColor = .white
        infoCell.textColor = .white
        
        infoImage.contentMode = .scaleAspectFit
        infoImage.anchor(top: contentView.topAnchor,
                         bottom: titleCell.bottomAnchor,
                         leading: contentView.leadingAnchor,
                         paddingTop: 10,
                         paddingLeading: 10,
                         width: 20, height: 20)
        
        titleCell.anchor(top: infoImage.topAnchor,
                         leading: infoImage.trailingAnchor,
                         trailing: contentView.trailingAnchor,
                         paddingLeading: 5)
        
        infoCell.anchor(top: titleCell.bottomAnchor,
                        bottom: contentView.bottomAnchor,
                        leading: contentView.leadingAnchor,
                        trailing: titleCell.trailingAnchor,
                        paddingTop: 20, paddingBottom: 20)
    }
    
    private func bind() {
        viewModel?.infoTitle.bind({ [weak self] text in
            self?.titleCell.text = text
        })
        
        viewModel?.infoText.bind({ [weak self] text in
            self?.infoCell.text = text
        })
        
        viewModel?.image.bind({ [weak self] image in
            self?.infoImage.image = image
        })
    }

}
