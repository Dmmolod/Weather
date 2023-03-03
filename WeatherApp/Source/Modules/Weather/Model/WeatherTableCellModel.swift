//
//  WeatherTableCellModel.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 26.01.2023.
//

enum WeatherTableCellModel {
    case hourlyCell(model: [HourCollectionCellViewModel])
    case dailyCell(model: [DailyTableCellViewModel])
    case moreCell(model: MoreInfoCellViewModel)
    
    var count: Int {
        switch self {
        case .hourlyCell: return 1
        case .dailyCell(let model): return model.count
        case .moreCell: return 1
        }
    }
    
    var identifier: String {
        switch self {
        case .hourlyCell: return HourlyTableCell.identifier
        case .dailyCell: return DailyForecastCell.identifier
        case .moreCell: return MoreInfoCell.identifier
        }
    }
}
