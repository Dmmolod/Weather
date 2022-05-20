import Foundation

struct Forecast: Codable {
    var cityName: String
    let cityInfo: CityInfo
    let current: CurrentForescast
    let hourly: [HourForecast]
    let daily: [DayForecast]
}
