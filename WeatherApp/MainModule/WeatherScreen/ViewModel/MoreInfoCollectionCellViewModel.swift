import Foundation
import UIKit

class MoreInfoCollectionCellViewModel: MoreInfoCollectionCellViewModelType {
    
    private let currentForecast: CurrentForescast
    
    let image = Bindable<UIImage?>(nil)
    let infoTitle = Bindable<String>("")
    let infoText = Bindable<String>("")
    let description = Bindable<String?>(nil)
    
    init(_ currentForecast: CurrentForescast, itemType: MoreInfoItemsType) {
        self.currentForecast = currentForecast
        configure(with: itemType)
    }
    
    private func configure(with itemType: MoreInfoItemsType) {
        infoTitle.value = itemType.getTitleText()
        image.value = itemType.getTitleIcone()
        
        switch itemType {
        case .humidity:
            infoText.value = String(currentForecast.humidity) + "%"
        case .windSpeed:
            infoText.value = String(currentForecast.wind_speed) + " " + "m/s".localized
        case .feelsLike:
            infoText.value = String(currentForecast.feelsLike).withTempSymbol
        case .pressure:
            infoText.value = String(Int(currentForecast.pressure * 0.75)) + "\n" + "mmHg".localized
        }
    }
}
