import UIKit

final class WeatherViewController: UIViewController {
    
    private unowned let coordinator: WeatherScreenCoordinatorLogic
    private let viewModel: WeatherViewModel
    
    private let weatherView = WeatherView()
    
    init(coordinator: WeatherScreenCoordinatorLogic, viewModel: WeatherViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        weatherView.delegate = self
        bind()
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func loadView() {
        view = weatherView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    
    private func bind() {
        
        // MARK: - Bind buttons states
        viewModel.addToFavoritesButtonIsHidden.bind { [weak self] state in
            self?.weatherView.setAddToFavoritesButton(isHidden: state)
        }

        viewModel.cancelButtonIsHidden.bind { [weak self] state in
            self?.weatherView.setCancelButton(isHidden: state)
        }

        viewModel.showFavoritesButtonIsHidden.bind { [weak self] state in
            self?.weatherView.setShowFavoritesButton(isHidden: state)
        }

        // MARK: - Bind forecast values state
        viewModel.forecastCityName.bind { [weak self] city in
            self?.weatherView.setCityName(city)
        }

        viewModel.forecastCurrentDegrees.bind { [weak self] degrees in
            self?.weatherView.setDegrees(degrees)
        }

        // MARK: - Bind ready forecast state
        viewModel.isModelLoaded.bind { [weak self] isLoaded in
            self?.weatherView.setSpinner(isHidden: isLoaded)
        }
        
        viewModel.forecastCellModels.bind { [weak self] cellModels in
            self?.weatherView.updateTable(with: cellModels)
        }
        
        // MARK: - Work with gradient
        viewModel.gradientType.bind { [weak self] gradientType in
            let colors = gradientType.gradient()
            self?.weatherView.setGradient(with: colors)
        }
    }
    
}

extension WeatherViewController: WeatherViewDelegate {
    func weatherViewDidTapCancel(_ weatherView: WeatherView) {
        coordinator.didTapCancel()
    }
    
    func weatherViewDidTapShowFavorites(_ weatherView: WeatherView) {
        coordinator.didTapShowFavorites()
    }
    
    func weatherViewDidTapAddToFavorites(_ weatherView: WeatherView) {
        coordinator.didTapAddToFavorites()
        viewModel.addButtonPressed()
    }
}
