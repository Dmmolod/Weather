import Foundation
import UIKit

class SearchCell: UITableViewCell {
    
    static let identifier = "SearchCell"
    var viewModel: SearchCellViewModel? {
        didSet {
            bind()
        }
    }
    private let cityName = UILabel()
    private let countryName = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupElements()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind() {
        viewModel?.cityName.bind({ [weak self] cityName in
            self?.cityName.text = cityName
        })
        
        viewModel?.country.bind({ [weak self] countryName in
            self?.countryName.text = countryName
        })
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        layer.cornerRadius = 20
        
        [cityName, countryName].forEach { contentView.addSubview($0) }
        
        cityName.anchor(top: contentView.topAnchor,
                        bottom: contentView.bottomAnchor,
                        leading: contentView.leadingAnchor,
                        trailing: contentView.centerXAnchor,
                        paddingLeading: Constans.leftInset)
        
        countryName.anchor(top: cityName.topAnchor,
                           bottom: cityName.bottomAnchor,
                           leading: contentView.centerXAnchor,
                           trailing: contentView.trailingAnchor,
                           paddingTrailing: Constans.rightInset)
    }
    
    private func setupElements() {
        countryName.textAlignment = .right
        countryName.font = .systemFont(ofSize: 13, weight: .light)
        countryName.adjustsFontSizeToFitWidth = true
    }
}
