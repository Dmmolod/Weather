import Foundation
import UIKit

class WeatherView: UIView {
    
    private let cityLabel: UILabel
    private let currentDegreesLable: UILabel
    private var addToFavouritesButton:  UIButton
    private var cancelButton: UIButton
    private var showFavouritesButton: UIButton
    private let weatherTable: WeatherTable
    private let spinner: UIActivityIndicatorView
    private let gradient: CAGradientLayer
        
    init(cityLabel: UILabel,
         currentDegreesLable: UILabel,
         addToFavouritesButton: UIButton,
         cancelButton: UIButton,
         showFavouritesButton: UIButton,
         weatherTable: WeatherTable,
         spinner: UIActivityIndicatorView,
         gradient: CAGradientLayer) {
        
        self.cityLabel = cityLabel
        self.currentDegreesLable = currentDegreesLable
        self.addToFavouritesButton = addToFavouritesButton
        self.cancelButton = cancelButton
        self.showFavouritesButton = showFavouritesButton
        self.weatherTable = weatherTable
        self.spinner = spinner
        self.gradient = gradient
        
        super.init(frame: .zero)
        setupConstaints()
        setupUI()
        backgroundColor = weatherTable.backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        gradient.frame = self.bounds
    }
    
    private func setupConstaints() {
        [cityLabel, currentDegreesLable, weatherTable, spinner, addToFavouritesButton, cancelButton, showFavouritesButton].forEach({ addSubview($0) })
        
        cityLabel.anchor(top: safeAreaLayoutGuide.topAnchor,
                         leading: leadingAnchor,
                         trailing: trailingAnchor,
                         paddingTop: Constans.topInset+20,
                         paddingLeading: 10,
                         paddingTrailing: 10)
        
        currentDegreesLable.anchor(top: cityLabel.bottomAnchor,
                                   leading: leadingAnchor,
                                   trailing: trailingAnchor,
                                   paddingTop: Constans.topInset)
        
        weatherTable.anchor(top: currentDegreesLable.bottomAnchor,
                            bottom: bottomAnchor,
                            leading: leadingAnchor,
                            trailing: trailingAnchor,
                            paddingTop: Constans.topInset)
        
        showFavouritesButton.anchor(top: safeAreaLayoutGuide.topAnchor,
                                    trailing: trailingAnchor,
                                    paddingTop: Constans.topInset,
                                    paddingTrailing: Constans.rightInset)
        
        cancelButton.anchor(top: safeAreaLayoutGuide.topAnchor,
                            leading: leadingAnchor,
                            paddingLeading: Constans.leftInset)
        
        addToFavouritesButton.anchor(top: cancelButton.topAnchor,
                         trailing: trailingAnchor,
                         paddingTrailing: Constans.rightInset)
        
        spinner.centerY(inView: self)
        spinner.centerX(inView: self)
    }
    
    private func setupUI() {

        spinner.style = .large
        spinner.startAnimating()
        
        self.layer.insertSublayer(gradient, at: 0)
     
        gradient.startPoint = GradientPoint.topLeading.choose()
        gradient.endPoint = GradientPoint.bottomTrailing.choose()
        
        [cityLabel, currentDegreesLable].forEach({
            $0.text = "- -"
            $0.textAlignment = .center
            $0.textColor = .white
        })
        
        cityLabel.font = .systemFont(ofSize: 20)
        cityLabel.adjustsFontSizeToFitWidth = true
        currentDegreesLable.font = .systemFont(ofSize: 16)
        
        [cancelButton, addToFavouritesButton, showFavouritesButton].forEach({
            $0.configuration?.cornerStyle = .capsule
            $0.tintColor = .white
        })
        
        showFavouritesButton.setImage(UIImage(systemName: "list.star")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        showFavouritesButton.isHidden = false
        
        cancelButton.configuration?.title = "Cancel".localized
        cancelButton.isHidden = true
        
        addToFavouritesButton.configuration?.title = "Add".localized
        addToFavouritesButton.isHidden = true
    }
}
