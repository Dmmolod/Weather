import UIKit


class WeatherTable: UITableView {
    
    var viewModel: WeatherViewModelType?
    
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
}

extension WeatherTable: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Data source
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRowsInSection(for: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        
        var resultCell: UITableViewCell?
        let sectionType = viewModel.sectionType(for: indexPath.section)
        
        switch sectionType {
        case .hourly:
            let tempCell = tableView.dequeueReusableCell(withIdentifier: HourlyTableCell.identifier,
                                                           for: indexPath) as? HourlyTableCell
            
            let hourlyViewModelType = viewModel.hourlyTableCellViewModelType()
            tempCell?.viewModel = hourlyViewModelType
            resultCell = tempCell

        case .daily:
            let tempCell = tableView.dequeueReusableCell(withIdentifier: DailyForecastCell.identifier,
                                                           for: indexPath) as? DailyForecastCell
            
            let dailyTableCellViewModelType = viewModel.dailyTableCellViewModelType(for: indexPath)
            tempCell?.viewModel = dailyTableCellViewModelType
            resultCell = tempCell

        case .moreInfo:
            let tempCell = tableView.dequeueReusableCell(withIdentifier: MoreInfoCell.identifier,
                                                           for: indexPath) as? MoreInfoCell
            
            tempCell?.viewModel = viewModel.moreInfoTableCellViewModelType()
            resultCell = tempCell
        }

        guard let cell = resultCell else { return UITableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let viewModel = viewModel else { return nil }
        
        let sectionType = viewModel.sectionType(for: section)
        
        switch sectionType {
        case .hourly:
            return "Hourly forecast".localized
        case .daily:
            return "Daily forecast for 7 days".localized
        case .moreInfo:
            return "More info".localized
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as? UITableViewHeaderFooterView)?.textLabel?.textColor = .white
    }
    
    // MARK: Delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let viewModel = viewModel else { return 0 }
        
        let sectionType = viewModel.sectionType(for: indexPath.section)
        
        switch sectionType {
        case .hourly:
            return Constans.hourlyCellHeight
        case .daily:
            return Constans.dayliCellHeight
        case .moreInfo:
            return UITableView.automaticDimension
        }
    }
}
