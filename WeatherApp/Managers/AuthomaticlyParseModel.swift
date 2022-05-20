import Foundation

struct ForecastResponse: Decodable {
    let timezone_offset: Double
    let daily: [DayForecastModel]
    let current: CurrentForecastModel
    let hourly: [HourForecastModel]
  
    func convertToForecastType(with cityName: String, _ cityInfo: CityInfo) -> Forecast {
        let dailyForecast: [DayForecast] = daily.map { dayForecastInfo in
            
            return DayForecast(date: dayForecastInfo.dt.transformToDate(timezone_offset),
                               temp_max: Int(dayForecastInfo.temp.max),
                               temp_min: Int(dayForecastInfo.temp.min),
                               iconID: dayForecastInfo.weather.first?.icon ?? "none")
        }
        
        let hourlyForecast: [HourForecast] = hourly.map { hourForecastInfo in
            return HourForecast(date: hourForecastInfo.dt.transformToDate(timezone_offset),
                                temp: Int(hourForecastInfo.temp),
                                iconID: hourForecastInfo.weather.first?.icon ?? "none")
        }
        
        let currentForecast = CurrentForescast(
            date: current.dt.transformToDate(timezone_offset),
            temp: Int(current.temp),
            humidity: Int(current.humidity),
            pressure: current.pressure,
            feelsLike: Int(current.feels_like),
            wind_speed: Int(current.wind_speed),
            iconID: current.weather.first?.icon ?? "none",
            description: current.weather.first?.description ?? "",
            weatherState: current.weather.first?.main ?? "")
        
        return Forecast(cityName: cityName,
                        cityInfo: cityInfo,
                        current: currentForecast,
                        hourly: hourlyForecast,
                        daily: dailyForecast)
    }
}
struct CurrentForecastModel: Decodable {
    let temp: Double
    let humidity: Double
    let wind_speed: Double
    let feels_like: Double
    let pressure: Double
    let dt: Double
    let weather: [WeatherInfoModel]
}

struct HourForecastModel: Decodable {
    let dt: Double
    let temp: Double
    let weather: [WeatherInfoModel]
}

struct DayForecastModel: Decodable {
    let dt: Double
    let temp: TemperatureInfoModel
    let weather: [WeatherInfoModel]
}

struct TemperatureInfoModel: Decodable {
    let max: Double
    let min: Double
}

struct WeatherInfoModel: Decodable {
    let icon: String
    let description: String
    let main: String
}
