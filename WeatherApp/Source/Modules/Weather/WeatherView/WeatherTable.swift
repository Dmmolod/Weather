import UIKit

protocol WeatherTableViewModel: AnyObject {
    var forecastCellModels: Bindable<[WeatherTableCellModel]> { get }
}

final class WeatherTable: UITableView {
    
    private var sectionModels = [WeatherTableCellModel]()
    
    init() {
        super.init(frame: .zero, style: .insetGrouped)
            
        delegate = self
        dataSource = self
        backgroundColor = .clear
        register(HourlyTableCell.self, forCellReuseIdentifier: HourlyTableCell.identifier)
        register(DailyForecastCell.self, forCellReuseIdentifier: DailyForecastCell.identifier)
        register(MoreInfoCell.self, forCellReuseIdentifier: MoreInfoCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func reload(with cellModels: [WeatherTableCellModel]) {
        self.sectionModels = cellModels
        reloadData()
    }
}

extension WeatherTable: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Data source
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sectionModels[section].count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard let sectionModel = sectionModels[safe: indexPath.section] else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: sectionModel.identifier,
            for: indexPath
        )
        
        switch sectionModel {
        case let .hourlyCell(model):
            let tempCell = cell as? HourlyTableCell
            tempCell?.configure(model)
            
        case let .dailyCell(model):
            guard let dayModel = model[safe: indexPath.row] else { break }
            let tempCell = cell as? DailyForecastCell
            
            tempCell?.configure(dayModel)
            
        case let .moreCell(model):
            let tempCell = cell as? MoreInfoCell
            tempCell?.configure(model: model)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let sectionType = sectionModels[safe: section] else { return nil }
        
        switch sectionType {
        case .hourlyCell:
            return "Hourly forecast".localized
        case .dailyCell:
            return "Daily forecast for 7 days".localized
        case .moreCell:
            return "More info".localized
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as? UITableViewHeaderFooterView)?.textLabel?.textColor = .white
    }
    
    // MARK: Delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let sectionType = sectionModels[safe: indexPath.section] else { return UITableView.automaticDimension }
        
        switch sectionType {
        case .hourlyCell: return Constans.hourlyCellHeight
        case .dailyCell: return Constans.dayliCellHeight
        case .moreCell: return UITableView.automaticDimension
        }
    }
}
