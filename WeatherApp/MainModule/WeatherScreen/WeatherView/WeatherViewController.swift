import UIKit

protocol WeatherViewControllerDelegate: AnyObject {
    func addToFavouritesButtonPressed(_ forecast: Forecast)
}

class WeatherViewController: UIViewController, AnimatableTransitionIntoTableCell {
    
    weak var delegate: WeatherViewControllerDelegate?
    var coordinator: MainCoordinator?
    var viewModel: WeatherViewModelType?
    
    private lazy var weatherView = WeatherView(cityLabel: self.cityLabel,
                                               currentDegreesLable: self.currentDegreesLable,
                                               addToFavouritesButton: self.addToFavouritesButton,
                                               cancelButton: self.cancelButton,
                                               showFavouritesButton: self.showFavouritesButton,
                                               weatherTable: self.weatherTable,
                                               spinner: self.spinner,
                                               gradient: self.gradient)
    
    private let gradient = CAGradientLayer()
    private let cityLabel = UILabel()
    private let currentDegreesLable = UILabel()
    private let showFavouritesButton = UIButton(configuration: .plain())
    private let cancelButton = UIButton(configuration: .plain())
    private let addToFavouritesButton = UIButton(configuration: .plain())
    private let weatherTable = WeatherTable()
    private let spinner = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = weatherView
        
        weatherTable.viewModel = viewModel
        bind()
        addActionsForButtons()
    }
    
    private func addActionsForButtons() {
        
        showFavouritesButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.toFavouritesScreen()
        }, for: .touchUpInside)
        
        cancelButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.dismiss(self, animated: true, modalTransitionStyle: .coverVertical)
        }, for: .touchUpInside)
        
        addToFavouritesButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.dismiss(self, animated: true)
            self?.viewModel?.addButtonPressed()
        }, for: .touchUpInside)
    }
    
    private func bind() {
        
        // MARK: Bind buttons state
        viewModel?.addToFavouritesButtonIsHidden.bind { [weak self] state in
            self?.addToFavouritesButton.isHidden = state
        }

        viewModel?.cancelButtonIsHidden.bind { [weak self] state in
            self?.cancelButton.isHidden = state
        }

        viewModel?.showFavouritesButtonIsHidden.bind { [weak self] state in
            self?.showFavouritesButton.isHidden = state
        }

        // MARK: Bind forecast values state

        viewModel?.forecastCityName.bind { [weak self] city in
            self?.cityLabel.text = city
        }

        viewModel?.forecastCurrentDegrees.bind { [weak self] degrees in
            self?.currentDegreesLable.text = degrees
        }
        
        viewModel?.cityForecastForAddToFavourites.bind { [weak self] cityForecastToFavourites in
            guard let cityForecastToFavourites = cityForecastToFavourites else { return }
            self?.delegate?.addToFavouritesButtonPressed(cityForecastToFavourites)
        }

        // MARK: Bind ready forecast state

        viewModel?.forecastIsUpdate.bind { [weak self] state in
            self?.spinner.isHidden = state
            self?.weatherTable.reloadData()
        }
        
        // MARK: Work with gradient
        
        viewModel?.gradientType.bind({ [weak self] gradientType in
            self?.gradient.colors = VisualWeatherModel.gradient(gradientType.weatherState, time: gradientType.dayTime)
        })
    }
    
    func getIndexPath() -> IndexPath? {
        return viewModel?.transitionCellIndexPath
    }
}
