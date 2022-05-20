import Foundation
import UIKit

enum VisualWeatherModel {
    
    enum WeatherState: String {
        case clear
        case clouds
        case rain
        case snow
    }
    
    enum DayTime {
        case day
        case evening
        case night
        
        func color() -> CGColor {
            switch self {
            case .day:
                return UIColor.systemBlue.cgColor
            case .evening:
                return UIColor.blue.cgColor
            case .night:
                return UIColor.systemIndigo.cgColor
            }
        }
    }
    
    static func dayType(from time: Int) -> DayTime {
        var dayTimeType: DayTime = .day
        switch time {
        case 0..<7: dayTimeType = .night
        case 7..<18: dayTimeType = .day
        case 18...23: dayTimeType = .evening
        default: dayTimeType = .day
        }
        return dayTimeType
    }
    
    static func gradient(_ weather: WeatherState, time: DayTime) -> [CGColor] {
        let topColor: CGColor
        let mainColor = time.color()
        
        switch weather {
        case .clear:
            switch time {
            case .day:
                topColor = UIColor.systemGray5.cgColor
            case .evening:
                topColor = UIColor.systemOrange.cgColor
            case .night:
                topColor = UIColor.black.cgColor
            }
        case .clouds:
            topColor = UIColor.gray.cgColor
        case .rain:
            topColor = UIColor.darkGray.cgColor
        case .snow:
            topColor = UIColor.systemMint.cgColor
        }
        
        return [topColor, mainColor]
    }
}

enum GradientPoint {
    case topLeading
    case top
    case topTrailing
    case leading
    case center
    case trailing
    case bottomLeading
    case bottom
    case bottomTrailing
    
    func choose() -> CGPoint {
        switch self {
    
        case .topLeading:
            return CGPoint(x: 0, y: 0)
        case .leading:
            return CGPoint(x: 0, y: 0.5)
        case .bottomLeading:
            return CGPoint(x: 0, y: 1)
        case .top:
            return CGPoint(x: 0.5, y: 0)
        case .center:
            return CGPoint(x: 0.5, y: 0.5)
        case .bottom:
            return CGPoint(x: 0.5, y: 1)
        case .topTrailing:
            return CGPoint(x: 1, y: 0)
        case .trailing:
            return CGPoint(x: 1, y: 0.5)
        case .bottomTrailing:
            return CGPoint(x: 1, y: 1)
        }
    }
    
}
