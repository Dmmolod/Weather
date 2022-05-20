import Foundation
import UIKit

class FavouriteCityCell: UITableViewCell {
    
    static let identifier = "FavouriteCityCell"
    
    var viewModel: FavouriteCityCellViewModel? {
        didSet {
            bind()
        }
    }
    
    private let headerTitle = UILabel()
    private let subTitle = UILabel()
    private let descriptionTitle = UILabel()
    private let currentTemperatureTitle = UILabel()
    private let infoTemperatureTitle = UILabel()
    private let icon = UIImageView()
    private let gradient = CAGradientLayer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layer.cornerRadius = 30
        clipsToBounds = true
        setupUI()
        setupElements()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = 30
        if gradient.frame.height <= bounds.height {
            gradient.frame = bounds
        }
    }

    
    func bind() {
        
        viewModel?.headerTitle.bind { [weak self] text in
            self?.headerTitle.text = text
        }
        
        viewModel?.subTitle.bind { [weak self] text in
            self?.subTitle.text = text
        }
        
        viewModel?.descriptionTitle.bind { [weak self] text in
            self?.descriptionTitle.text = text
        }
        
        viewModel?.currentTemperatureTitle.bind { [weak self] text in
            self?.currentTemperatureTitle.text = text
        }
        
        viewModel?.infoTemperatureTitle.bind { [weak self] text in
            self?.infoTemperatureTitle.text = text
        }
        
        viewModel?.icon.bind { [weak self] icon in
            self?.icon.image = icon
        }
        
        viewModel?.gradientType.bind({ [weak self] gradientType in
            self?.gradient.colors = VisualWeatherModel.gradient(gradientType.weatherState, time: gradientType.dayTime)
        })
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .systemGray5
        
        contentView.layer.insertSublayer(gradient, at: 0)
                
        [headerTitle, subTitle, descriptionTitle, currentTemperatureTitle, infoTemperatureTitle, icon].forEach {
            contentView.addSubview($0)
        }
        
        headerTitle.anchor(top: contentView.topAnchor,
                           leading: contentView.leadingAnchor,
                           trailing: contentView.centerXAnchor,
                           paddingTop: Constans.topInset,
                           paddingLeading: Constans.leftInset)
        
        subTitle.anchor(top: headerTitle.bottomAnchor,
                        leading: headerTitle.leadingAnchor,
                        paddingTop: 5)
        
        descriptionTitle.anchor(bottom: contentView.bottomAnchor,
                                leading: subTitle.leadingAnchor,
                                trailing: contentView.centerXAnchor,
                                paddingBottom: Constans.bottomInset,
                                paddingTrailing: -10)
        
        currentTemperatureTitle.anchor(top: headerTitle.topAnchor,
                                       trailing: contentView.trailingAnchor,
                                       paddingLeading: Constans.leftInset,
                                       paddingTrailing: Constans.rightInset)
        
        infoTemperatureTitle.anchor(top: descriptionTitle.topAnchor,
                                    bottom: descriptionTitle.bottomAnchor,
                                    leading: contentView.centerXAnchor,
                                    trailing: currentTemperatureTitle.trailingAnchor,
                                    paddingLeading: 10)
        
        icon.anchor(top: currentTemperatureTitle.topAnchor,
                    bottom: infoTemperatureTitle.topAnchor,
                    leading: contentView.centerXAnchor,
                    paddingTrailing: 10)
    }
    
    private func setupElements() {
        gradient.startPoint = GradientPoint.topLeading.choose()
        gradient.endPoint = GradientPoint.bottomTrailing.choose()
        
        [headerTitle, subTitle,descriptionTitle,currentTemperatureTitle,infoTemperatureTitle].forEach({
            $0.adjustsFontSizeToFitWidth = true
            $0.numberOfLines = 2
            $0.textColor = .white
        })
        headerTitle.font = .systemFont(ofSize: 20, weight: .heavy)
        subTitle.font = .systemFont(ofSize: 15, weight: .light)
        descriptionTitle.font = .systemFont(ofSize: 15, weight: .light)
        descriptionTitle.numberOfLines = 0
        
        currentTemperatureTitle.font = .systemFont(ofSize: 40, weight: .regular)
        infoTemperatureTitle.font = .systemFont(ofSize: 15, weight: .medium)
        infoTemperatureTitle.textAlignment = .right
        
        icon.contentMode = .scaleAspectFit
    }
    
}
    
