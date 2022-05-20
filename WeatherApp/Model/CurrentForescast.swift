import Foundation

struct CurrentForescast: Codable {
    let date: Date
    let temp: Int
    let humidity: Int
    let pressure: Double
    let feelsLike: Int
    let wind_speed: Int
    let iconID: String
    let description: String
    let weatherState: String
}
