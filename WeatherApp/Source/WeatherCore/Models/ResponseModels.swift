struct ForecastResponse: Decodable {
    let timezoneOffset: Double
    let daily: [DayForecastResponse]
    let current: CurrentForecastResponse
    let hourly: [HourForecastResponse]
    
    enum CodingKeys: String, CodingKey {
        case timezoneOffset = "timezone_offset"
        case daily, current, hourly
    }
}

struct CurrentForecastResponse: Decodable {
    let temp: Double
    let humidity: Double
    let windSpeed: Double
    let feelsLike: Double
    let pressure: Double
    let dt: Double
    let weather: [WeatherInfoResponse]
    
    enum CodingKeys: String, CodingKey {
        case temp, humidity, pressure, dt, weather
        case windSpeed = "wind_speed"
        case feelsLike = "feels_like"
    }
}

struct HourForecastResponse: Decodable {
    let dt: Double
    let temp: Double
    let weather: [WeatherInfoResponse]
}

struct DayForecastResponse: Decodable {
    let dt: Double
    let temp: TemperatureInfoResponse
    let weather: [WeatherInfoResponse]
}

struct TemperatureInfoResponse: Decodable {
    let max: Double
    let min: Double
}

struct WeatherInfoResponse: Decodable {
    let icon: String
    let description: String
    let main: String
}
