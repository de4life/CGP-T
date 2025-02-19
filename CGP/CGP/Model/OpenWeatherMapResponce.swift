


import Foundation

struct WeatherResponse: Codable {
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let name: String
    
    struct Main: Codable {
        let temp: Double
        let temp_min: Double
        let temp_max: Double
        let humidity: Int
    }

    struct Weather: Codable {
        let main: String
        let icon: String
        let description: String
    }

    struct Wind: Codable {
        let speed: Double
    }
}

struct ForecastResponse: Codable {
    let list: [ForecastItem]
    
    struct ForecastItem: Codable {
        let dt: Int
        let main: WeatherResponse.Main
        let weather: [WeatherResponse.Weather]
    }
}
