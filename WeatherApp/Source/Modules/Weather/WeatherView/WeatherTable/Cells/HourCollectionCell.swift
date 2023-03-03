import UIKit

final class HourCollectionCell: UICollectionViewCell {
    private let timeTitle = UILabel()
    private let weatherIcon = UIImageView()
    private let temperatureTitle = UILabel()
    private let loadSpinner = UIActivityIndicatorView(style: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        loadSpinner.startAnimating()
        loadSpinner.isHidden = false
    }
    
    func configure(with model: HourCollectionCellViewModelType) {
        timeTitle.text = model.time
        temperatureTitle.text = model.temperature
        
        model.icon.bind { [weak self] icon in
            self?.loadSpinner.stopAnimating()
            self?.loadSpinner.isHidden = true
            self?.weatherIcon.image = icon
        }
    }
    
    private func setupUI() {
        backgroundColor = .clear
        [timeTitle, weatherIcon, loadSpinner, temperatureTitle].forEach({contentView.addSubview($0)})
        [timeTitle, temperatureTitle].forEach({
            $0.text = "- -"
            $0.textAlignment = .center
            $0.textColor = .white
        })
        weatherIcon.contentMode = .scaleAspectFit
        
        loadSpinner.color = .white
        loadSpinner.startAnimating()
    }
    
    private func setupConstraint() {
        [contentView].forEach {
            timeTitle.anchor(
                top: $0.topAnchor,
                leading: $0.leadingAnchor,
                trailing: $0.trailingAnchor
            )
            timeTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            weatherIcon.anchor(
                top: timeTitle.bottomAnchor,
                leading: timeTitle.leadingAnchor,
                trailing: timeTitle.trailingAnchor
            )
            weatherIcon.widthAnchor.constraint(equalTo: $0.widthAnchor).isActive = true
            
            loadSpinner.centerX(inView: weatherIcon)
            loadSpinner.centerY(inView: weatherIcon)
            
            temperatureTitle.anchor(
                top: weatherIcon.bottomAnchor,
                bottom: $0.bottomAnchor,
                leading: weatherIcon.leadingAnchor,
                trailing: weatherIcon.trailingAnchor
            )
            temperatureTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
    }
}
