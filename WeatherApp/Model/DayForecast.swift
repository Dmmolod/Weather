import Foundation

struct DayForecast: Codable {
    
    let date: Date
    let temp_max: Int
    let temp_min: Int
    let iconID: String
}
