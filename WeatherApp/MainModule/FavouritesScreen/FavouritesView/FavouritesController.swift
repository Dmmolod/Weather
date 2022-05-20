import Foundation
import UIKit

class FavouritesController: UIViewController, AnimatableTransitionFromTableCell {
        
    var viewModel: FavouritesViewModelType? {
        didSet { bind() }
    }
    var coordinator: MainCoordinator?
    
    private lazy var favouritesView = FavouritesView(screenTitle: self.screenTitle,
                                                     searchField: self.searchField,
                                                     resultTable: self.resultTable,
                                                     cancelButton: self.cancelButton,
                                                     shadowEffectView: self.shadowEffectView)
    
    private var hideKeyboardRecognizer = UITapGestureRecognizer()
    private let screenTitle = UILabel()
    private let searchField = UISearchTextField()
    private let resultTable = ResultTable()
    private let cancelButton = UIButton()
    private let shadowEffectView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.startUpdateTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel?.killUpdateTimer()
    }
    
    private func setupElements() {
        
        view = favouritesView
        resultTable.viewModel = viewModel
        searchField.delegate = self
        
        cancelButton.addAction(UIAction { [weak self] _ in
            self?.viewModel?.cancelSearch()
        }, for: .touchUpInside)
        
        hideKeyboardRecognizer = UITapGestureRecognizer(target: self,
                                                        action: #selector(tapToHideKeyboard))
        
        favouritesView.addGestureRecognizer(hideKeyboardRecognizer)
    }
    
    @objc func tapToHideKeyboard() {
        viewModel?.hideKeyboard()
    }
    
    private func bind() {
        
        viewModel?.searchIsActive.addListener { [weak self] state in
            self?.favouritesView.animateElementsWith(searchState: state)
        }
        
        viewModel?.shadowEffectIsHide.bind { [weak self] state in
            self?.shadowEffectView.isHidden = state
        }
        
        viewModel?.hideKeyboardRecognizerIsEnable.bind { [weak self] state in
            self?.hideKeyboardRecognizer.isEnabled = state
        }
        
        viewModel?.endEditing.addListener { [weak self] state in
            self?.favouritesView.endEditing(state)
        }
        
        viewModel?.searchFieldText.bind { [weak self] text in
            self?.searchField.text = text
        }
        
        viewModel?.tableIsUpdate.bind { [weak self] _ in
            self?.resultTable.reloadData()
        }
        
        viewModel?.selectedCityCoordinate.bind { [weak self] cityInfo in
            guard let cityInfo = cityInfo else { return }
            self?.coordinator?.presentWeatherScreen(with: cityInfo)
        }
        
        viewModel?.selectedFavouriteCity.bind { [weak self] cityForecast in
            guard let cityForecast = cityForecast,
                  let indexPath = self?.viewModel?.selectedCellIndexPath else { return }
            self?.coordinator?.toWeatherScreen(with: cityForecast, from: indexPath)
        }
    }
    
    func getAnimateCell(from indexPath: IndexPath) -> UITableViewCell? {
        resultTable.cellForRow(at: indexPath)
    }
    
    func getTable() -> UITableView {
        resultTable
    }
    
    
    func getIndexPath() -> IndexPath? {
        viewModel?.selectedCellIndexPath
    }
}

extension FavouritesController: UISearchTextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        viewModel?.searchFieldShouldBeginEditind(with: textField.text)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel?.searchFieldShouldReturn()
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        viewModel?.textInput(textField.text, replacementString: string)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel?.searchFieldShouldClear()
        return true
    }
}

extension FavouritesController: WeatherViewControllerDelegate {
    func addToFavouritesButtonPressed(_ forecast: Forecast) {
        viewModel?.addToFavourites(forecast)
    }
}
