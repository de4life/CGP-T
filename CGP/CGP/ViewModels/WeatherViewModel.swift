import Foundation
import SwiftUI
import CoreLocation

class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var weather: WeatherResponse?
    @Published var forecast: [ForecastResponse.ForecastItem] = []
    @Published var cityName: String = "Current"
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var canNavigate: Bool = false
    
    private let apiKey = "0a6b34bdd693d726dd67de4156a39c69"
    
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func showErrorAlert(message: String) {
        alertMessage = message
        showAlert = true
        canNavigate = false
    }
    private func resetNavigation() {
        canNavigate = true
    }
    
    func fetchWeather(for city: String) {
        self.cityName = city
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&appid=\(apiKey)"
        
        fetchData(urlString: urlString) { (result: Result<WeatherResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.weather = data
                    self.resetNavigation()
                case .failure(let error):
                    print("Weather loading error:", error)
                    self.showErrorAlert(message: "City not found. Please check your input..")
                }
            }
        }
        fetchForecast(for: city)
    }

    
    func fetchWeather(lat: Double, lon: Double) {
        self.cityName = "Current"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)"
        fetchData(urlString: urlString) { (result: Result<WeatherResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.weather = data
                case .failure(let error):
                    print("Weather loading error:", error)
                }
            }
        }
    }
    
    func fetchForecast(lat: Double, lon: Double) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)"
        fetchData(urlString: urlString) { (result: Result<ForecastResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.forecast = data.list
                case .failure(let error):
                    print("Weather loading error:", error)
                }
            }
        }
    }

    func updateLocation() {
        guard let location = currentLocation else { return }

        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude

        fetchWeather(lat: lat, lon: lon)
        fetchForecast(lat: lat, lon: lon) 
    }

    
    func fetchForecast(for city: String) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&units=metric&appid=\(apiKey)"
        fetchData(urlString: urlString) { (result: Result<ForecastResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.forecast = data.list
                case .failure(let error):
                    print("Weather loading error:", error)
                }
            }
        }
    }

    
    private func fetchData<T: Codable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

extension WeatherViewModel {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
            if cityName == "Current" {
                updateLocation()
            }
        }
    }
}

