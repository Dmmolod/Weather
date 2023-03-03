import UIKit

protocol WeatherViewDelegate: AnyObject {
    func weatherViewDidTapAddToFavorites(_ weatherView: WeatherView)
    func weatherViewDidTapCancel(_ weatherView: WeatherView)
    func weatherViewDidTapShowFavorites(_ weatherView: WeatherView)
}

final class WeatherView: UIView {
    
    weak var delegate: WeatherViewDelegate?
    
    //MARK: - Views
    private let cityLabel = UILabel()
    private let currentDegreesLable = UILabel()
    private let addToFavoritesButton = UIButton(configuration: .plain())
    private let cancelButton = UIButton(configuration: .plain())
    private let showFavoritesButton = UIButton(configuration: .plain())
    private let weatherTable = WeatherTable()
    private let spinner = UIActivityIndicatorView()
    private let gradient = CAGradientLayer()
        
    //MARK: - Initializers
    init() {
        super.init(frame: .zero)
        setupActions()
        setupUI()
        setupConstaints()
        
        backgroundColor = weatherTable.backgroundColor
    }
    
    required init?(coder: NSCoder) { nil }
    
    //MARK: - Override Methods
    override func layoutSubviews() {
        gradient.frame = self.bounds
    }
    
    //MARK: - API
    func updateTable(with model: [WeatherTableCellModel]) {
        weatherTable.reload(with: model)
    }
    
    func setSpinner(isHidden: Bool) {
        isHidden ? spinner.stopAnimating() : spinner.startAnimating()
        spinner.isHidden = isHidden
    }
    
    func setAddToFavoritesButton(isHidden: Bool) {
        addToFavoritesButton.isHidden = isHidden
    }
    
    func setCancelButton(isHidden: Bool) {
        cancelButton.isHidden = isHidden
    }
    
    func setShowFavoritesButton(isHidden: Bool) {
        showFavoritesButton.isHidden = isHidden
    }
    
    func setCityName(_ text: String) {
        cityLabel.text = text
    }
    
    func setDegrees(_ text: String?) {
        currentDegreesLable.text = text
    }
    
    func  setGradient(with colors: [CGColor]) {
        self.gradient.colors = colors
    }
    
    //MARK: - Private Methods
    private func setupActions() {
        addToFavoritesButton.addTarget(self, action: #selector(didTapAddToFavorites), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        showFavoritesButton.addTarget(self, action: #selector(didTapShowFavorites), for: .touchUpInside)
    }
    
    @objc
    private func didTapCancel() {
        delegate?.weatherViewDidTapCancel(self)
    }
    
    @objc
    private func didTapAddToFavorites() {
        delegate?.weatherViewDidTapAddToFavorites(self)
    }
    
    @objc
    private func didTapShowFavorites() {
        delegate?.weatherViewDidTapShowFavorites(self)
    }
}

//MARK: - Private Layout
private extension WeatherView {
    
    private func setupUI() {

        spinner.style = .large
        
        self.layer.insertSublayer(gradient, at: 0)
     
        gradient.startPoint = GradientPoint.topLeading.cgPoint
        gradient.endPoint = GradientPoint.bottomTrailing.cgPoint
        
        [cityLabel, currentDegreesLable].forEach({
            $0.textAlignment = .center
            $0.textColor = .white
        })
        
        cityLabel.font = .systemFont(ofSize: 20)
        cityLabel.adjustsFontSizeToFitWidth = true
        currentDegreesLable.font = .systemFont(ofSize: 16)
        
        [cancelButton, addToFavoritesButton, showFavoritesButton].forEach({
            $0.configuration?.cornerStyle = .capsule
            $0.tintColor = .white
        })
        
        showFavoritesButton.setImage(
            UIImage(systemName: "list.star")?.withTintColor(.white, renderingMode: .alwaysOriginal),
            for: .normal
        )
        showFavoritesButton.isHidden = false
        
        cancelButton.configuration?.title = "Cancel".localized
        cancelButton.isHidden = true
        
        addToFavoritesButton.configuration?.title = "Add".localized
        addToFavoritesButton.isHidden = true
    }
    
    private func setupConstaints() {
        [
            cityLabel,
            currentDegreesLable,
            weatherTable,
            spinner,
            addToFavoritesButton,
            cancelButton,
            showFavoritesButton
        ].forEach({ addSubview($0) })
        
        cityLabel.anchor(
            top: showFavoritesButton.bottomAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            paddingTop: Constans.topInset,
            paddingLeading: 10,
            paddingTrailing: 10
        )
        
        currentDegreesLable.anchor(
            top: cityLabel.bottomAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            paddingTop: Constans.topInset
        )
        
        weatherTable.anchor(
            top: currentDegreesLable.bottomAnchor,
            bottom: bottomAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            paddingTop: Constans.topInset
        )
        
        showFavoritesButton.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            trailing: trailingAnchor,
            paddingTop: Constans.topInset,
            paddingTrailing: Constans.rightInset
        )
        
        cancelButton.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            leading: leadingAnchor,
            paddingTop: Constans.topInset,
            paddingLeading: Constans.leftInset
        )
        
        addToFavoritesButton.anchor(
            top: cancelButton.topAnchor,
            trailing: trailingAnchor,
            paddingTop: Constans.topInset,
            paddingTrailing: Constans.rightInset
        )
        
        spinner.centerY(inView: self)
        spinner.centerX(inView: self)
    }
}
