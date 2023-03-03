import Foundation
import UIKit

struct SearchCellModel {
    var cityName: String
    var countryName: String
}

class SearchCell: UITableViewCell {
    
    private let cityName = UILabel()
    private let countryName = UILabel()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupElements()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with model: SearchCellViewModel) {
        cityName.text = model.cityName
        countryName.text = model.country
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        layer.cornerRadius = 20
        
        [cityName, countryName].forEach { contentView.addSubview($0) }
        
        cityName.anchor(
            top: contentView.topAnchor,
            bottom: contentView.bottomAnchor,
            leading: contentView.leadingAnchor,
            trailing: contentView.centerXAnchor,
            paddingLeading: Constans.leftInset
        )
        
        countryName.anchor(
            top: cityName.topAnchor,
            bottom: cityName.bottomAnchor,
            leading: contentView.centerXAnchor,
            trailing: contentView.trailingAnchor,
            paddingTrailing: Constans.rightInset
        )
    }
    
    private func setupElements() {
        countryName.textAlignment = .right
        countryName.font = .systemFont(ofSize: 13, weight: .light)
        countryName.adjustsFontSizeToFitWidth = true
    }
}
