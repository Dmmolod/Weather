import UIKit

protocol ResultTableViewModelProtocol: AnyObject {
    var iconService: WeatherIconService { get }
    var needUpdateTable: Bindable<Void> { get }
    var resultTableModel: Bindable<ResultTableViewModel> { get }
    func didSelectRow(at indexPath: IndexPath)
    func deleteFavorite(at indexPath: IndexPath, onSuccess: @escaping () -> ())
    func canEditRow(at indexPath: IndexPath) -> Bool
}

enum ResultTableViewModel {
    case search(items: [SearchCellViewModel])
    case favorites(items: [FavoriteCellViewModel])
    
    var info: (
        sectionsCount: Int,
        rowsCount: Int,
        cellIdentifier: String,
        editingStyle: UITableViewCell.EditingStyle
    ) {
        switch self {
        case let .search(items):
            return (
                1,
                items.count,
                SearchCell.identifier,
                .none
            )
        case let .favorites(items):
            return (
                items.count,
                1,
                FavoriteCityCell.identifier,
                .delete
            )
        }
    }
}

final class ResultTable: UITableView {

    private var model: ResultTableViewModel = .favorites(items: [])
    
    private var iconService: WeatherIconService?
    
    private var deleteFavoriteAction: (
        IndexPath,
        @escaping () -> ()
    ) -> () = {_,_ in}
    
    private var didSelectAction: (IndexPath) -> () = {_ in}
    private var canEditRowAction: (IndexPath) -> Bool = {_ in false}
        
    init() {
        super.init(frame: .zero, style: .grouped)
        setupTable()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func subscribe(with viewModel: ResultTableViewModelProtocol) {
        viewModel.resultTableModel.bind { [weak self] model in
            self?.model = model
        }
        
        viewModel.needUpdateTable.bind { [weak self] in
            self?.reloadData()
        }
        
        iconService = viewModel.iconService
        
        didSelectAction = { [weak viewModel] indexPath in
            viewModel?.didSelectRow(at: indexPath)
        }
        
        deleteFavoriteAction = { [weak viewModel] indexPath, onSuccess in
            viewModel?.deleteFavorite(at: indexPath, onSuccess: onSuccess)
        }
        
        canEditRowAction = { [weak viewModel] indexPath in
            viewModel?.canEditRow(at: indexPath) ?? false
        }
    }
    
    private func setupTable() {
        separatorStyle = .none
        
        delegate = self
        dataSource = self
        register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
        register(FavoriteCityCell.self, forCellReuseIdentifier: FavoriteCityCell.identifier)
    }
}

extension ResultTable: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Data source
    func numberOfSections(in tableView: UITableView) -> Int {
        model.info.sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.info.rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: model.info.cellIdentifier,
            for: indexPath
        )
        
        switch model {
        case let .search(models):
            guard let searchModel = models[safe: indexPath.row] else { break }
            (cell as? SearchCell)?.configure(with: searchModel)
            
        case let .favorites(models):
            guard let favoriteModel = models[safe: indexPath.section] else { break }
            (cell as? FavoriteCityCell)?.configure(with: favoriteModel)
        }
        
        return cell
    }
    
    // MARK: - Editing methods
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        canEditRowAction(indexPath)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return model.info.editingStyle
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        deleteFavoriteAction(indexPath) {
            let indexSet = IndexSet(integer: indexPath.section)
            
            tableView.deleteSections(
                indexSet,
                with: .fade
            )
        }
    }
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        let subviewIsEqualContainer = { (subview: UIView) -> Bool in
            String(describing: type(of: subview)) == "_UITableViewCellSwipeContainerView"
        }
        let subviewIsEqualActionPull = { (subview: UIView) -> Bool in
            String(describing: type(of: subview)) == "UISwipeActionPullView"
        }
        guard
            let swipeContainerView = tableView.subviews.first(where: subviewIsEqualContainer),
            let swipeActionPullView = swipeContainerView.subviews.first(where: subviewIsEqualActionPull),
            let actionButton = swipeActionPullView.subviews.first,
            let backgroundView = actionButton.subviews.first
        else { return }
        
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 30
        swipeActionPullView.clipsToBounds = true
        swipeActionPullView.layer.cornerRadius = 30
    }
        
    // MARK: - Selected delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectAction(indexPath)
    }
    
    // MARK: - Set sizes
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch model {
        case .search: return Constans.defaultTableHeight
        case .favorites: return Constans.favoriteCityCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return " "
    }
        
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
