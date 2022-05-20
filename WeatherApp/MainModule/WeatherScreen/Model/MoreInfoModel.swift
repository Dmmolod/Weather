import Foundation
import UIKit

enum MoreInfoItemsType: CaseIterable {
    
    case humidity
    case windSpeed
    case feelsLike
    case pressure
    
    func getTitleIcone() -> UIImage? {
        let resultImage: UIImage?
        
        switch self {
        case .humidity:
            resultImage = UIImage(systemName: "humidity")
        case .windSpeed:
            resultImage = UIImage(systemName: "wind")
        case .feelsLike:
            resultImage = UIImage(systemName: "thermometer")
        case .pressure:
            resultImage = UIImage(named: "pressure")
        }
        return resultImage?.withTintColor(.white, renderingMode: .alwaysOriginal)
    }
    
    func getTitleText() -> String {
        let resultString: String
        
        switch self {
        case .humidity:
            resultString = "humidity"
        case .windSpeed:
            resultString = "wind"
        case .feelsLike:
            resultString = "feels like"
        case .pressure:
            resultString = "pressure"
        }
        
        return resultString.localized.uppercased()
    }
}
