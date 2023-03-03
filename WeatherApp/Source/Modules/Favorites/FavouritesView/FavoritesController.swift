import Foundation
import UIKit

final class FavoritesController: UIViewController {
    
    private let viewModel: FavoritesViewModelType
    private let coordinator: FavoritesScreenCoordinatorLogic
    
    private let favoritesView = FavoritesView()
    private var hideKeyboardRecognizer: UITapGestureRecognizer!
    
    init(viewModel: FavoritesViewModelType, coordinator: FavoritesScreenCoordinatorLogic) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
        
        setupRecognizer()
        bind()
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func loadView() {
        view = favoritesView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }
    
    private func setupRecognizer() {
        hideKeyboardRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(tapToHideKeyboard)
        )
        
        favoritesView.addGestureRecognizer(hideKeyboardRecognizer)
    }
    
    @objc func tapToHideKeyboard() {
        viewModel.cancelSearch()
    }
    
    private func bind() {
        viewModel.searchIsActive.addListener { [weak self] state in
            self?.favoritesView.setSearch(isActive: state)
        }
        
        viewModel.shadowEffectIsHide.bind { [weak self] state in
            self?.favoritesView.setShadowEffect(isHidden: state)
        }
        
        viewModel.hideKeyboardRecognizerIsEnable.bind { [weak self] state in
            self?.hideKeyboardRecognizer.isEnabled = state
        }
        
        viewModel.endEditing.addListener { [weak self] state in
            self?.favoritesView.endEditing(state)
        }
        
        viewModel.searchFieldText.bind { [weak self] text in
            self?.favoritesView.setSearchTextFieldText(text)
        }
        
        viewModel.selectedCityCoordinate.bind { [weak self] cityInfo in
            guard let cityInfo = cityInfo else { return }
            self?.coordinator.didTapSearchCity(cityInfo)
        }
        
        viewModel.selectedFavoriteCity.bind { [weak self] forecast in
            guard let forecast else { return }
            self?.coordinator.didTapfavoriteForecast(forecast)
        }
        
        favoritesView.subscribeTable(with: viewModel)
        
        favoritesView.setupCancelButton { [weak self] in
            self?.viewModel.cancelSearch()
        }
        
        favoritesView.setupFavoritesSearchDelegate { [weak self] in
            
            $0.textShouldBeginEditing = { textField in
                self?.viewModel.searchFieldShouldBeginEditind(with: textField.text)
                return true
            }
            
            $0.shouldChangeText = { textField, _, string in
                self?.viewModel.textInput(textField.text, replacementString: string)
                return true
            }
            
            $0.shouldClear = { _ in
                self?.viewModel.searchFieldShouldClear()
                return true
            }
            
            $0.shouldReturn = { _ in
                self?.viewModel.searchFieldShouldReturn()
                return true
            }
        }
    }
}

extension FavoritesController: TableViewCellTransitionable {
    func zoomingCell() -> UITableViewCell? {
        guard
            let selectedIndexPath = viewModel.selectedCellIndexPath,
            let selectedCell = favoritesView.cellFor(selectedIndexPath)
        else  { return favoritesView.cellFor([0,0]) }
                
        return selectedCell
    }
}
