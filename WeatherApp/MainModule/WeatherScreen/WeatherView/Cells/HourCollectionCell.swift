import UIKit

class HourCollectionCell: UICollectionViewCell {
    
    static let identifier = "HourForecastCollectionCell"
    var viewModel: HourCollectionCellViewModelType? {
        didSet {
            bind()
        }
    }
    
    private let timeTitle = UILabel()
    private let weatherIcon = UIImageView()
    private let temperatureTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func bind() {
        viewModel?.time.bind({ [weak self] time in
            self?.timeTitle.text = time
        })
        
        viewModel?.icon.bind({ [weak self] icon in
            self?.weatherIcon.image = icon
        })
        
        viewModel?.temperature.bind({ [weak self] temperature in
            self?.temperatureTitle.text = temperature
        })
    }
    
    private func setupUI() {
        backgroundColor = .clear
        [timeTitle, weatherIcon, temperatureTitle].forEach({contentView.addSubview($0)})
        [timeTitle, temperatureTitle].forEach({
            $0.text = "- -"
            $0.textAlignment = .center
            $0.textColor = .white
        })
        weatherIcon.contentMode = .scaleAspectFit
    }
    
    private func setupConstraint() {
        [contentView].forEach({
            timeTitle.anchor(top: $0.topAnchor,
                             leading: $0.leadingAnchor,
                             trailing: $0.trailingAnchor)
            timeTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            weatherIcon.anchor(top: timeTitle.bottomAnchor,
                               leading: timeTitle.leadingAnchor,
                               trailing: timeTitle.trailingAnchor)
            weatherIcon.widthAnchor.constraint(equalTo: $0.widthAnchor).isActive = true
            
            temperatureTitle.anchor(top: weatherIcon.bottomAnchor,
                                    bottom: $0.bottomAnchor,
                                    leading: weatherIcon.leadingAnchor,
                                    trailing: weatherIcon.trailingAnchor)
            temperatureTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        })
    }
}
