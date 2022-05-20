import Foundation
import UIKit

class ResultTable: UITableView {
    
    var viewModel: FavouritesViewModelType?
        
    init() {
        super.init(frame: .zero, style: .grouped)
        setupTable()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupTable() {
        separatorStyle = .none
        
        delegate = self
        dataSource = self
        register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
        register(FavouriteCityCell.self, forCellReuseIdentifier: FavouriteCityCell.identifier)
    }
}

extension ResultTable: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: _ Data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows(in: section) ?? 0
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        guard let viewModel = viewModel else { return UITableViewCell() }
        
        switch viewModel.currentTableStyle() {
            
        case .search:
            let tempCell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as? SearchCell
            
            tempCell?.viewModel = viewModel.searchCellViewModel(for: indexPath)
            cell = tempCell
            
        case .favourites:
            let tempCell = tableView.dequeueReusableCell(withIdentifier: FavouriteCityCell.identifier, for: indexPath) as? FavouriteCityCell
            
            tempCell?.viewModel = viewModel.favouriteCityCellViewModel(for: indexPath)
            cell = tempCell
        }
        
        guard let cell = cell else { return UITableViewCell() }
        return cell
    }
    
        // MARK: Editing methods
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        viewModel?.canEditRow(at: indexPath) ?? false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        guard let viewModel = viewModel else { return .none }
        switch viewModel.currentTableStyle() {
        case .favourites: return .delete
        case .search: return .none
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle != .delete { return }
        
        viewModel?.deleteFavouriteCity(at: indexPath)
        
        tableView.deleteSections(IndexSet(integer: indexPath.section), with: .middle)
        reloadData()
    }
    
    // MARK: _ Delegate
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        guard let swipeContainerView = tableView.subviews.first(where: { String(describing: type(of: $0)) == "_UITableViewCellSwipeContainerView" }),
              let tableCell = swipeContainerView.subviews.first(where: { ($0 as? UITableViewCell) != nil }) as? UITableViewCell,
              let swipeActionPullView = swipeContainerView.subviews.first,
              String(describing: type(of: swipeActionPullView)) == "UISwipeActionPullView" else { return }
        
        swipeActionPullView.clipsToBounds = true
        swipeActionPullView.layer.cornerRadius = 30
        tableCell.contentView.layer.cornerRadius = 30
        tableCell.backgroundColor = .clear
        tableCell.contentView.clipsToBounds = true
    }
        
        // MARK: Selected delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelect(at: indexPath)
    }
    
        // MARK: Set sizes
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let viewModel = viewModel else { return 0 }
        switch viewModel.currentTableStyle() {
            
        case .search:
            return Constans.defaultTableHeight
        case .favourites:
            return Constans.favouriteCityCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return " "
    }
        
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
