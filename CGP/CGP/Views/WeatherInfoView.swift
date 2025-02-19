

import Foundation
import SwiftUI

struct WeatherInfoView: View {
    
    @ObservedObject  var contentViewModel: WeatherViewModel
    
    var body: some View {
        HStack(spacing: 20) {
            if let weather = contentViewModel.weather {
                WeatherInfoItem(icon: "rain", value: "\(weather.main.humidity)%")
                WeatherInfoItem(icon: "temp", value: "\(weather.main.temp)°C")
                WeatherInfoItem(icon: "wind", value: "\(Int(weather.wind.speed)) km/h")
            } else {
                Text("Loading...").foregroundColor(.white)
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0, green: 0.063, blue: 0.149).opacity(0.4))
                
                .cornerRadius(20)
        }
    }
}

struct WeatherInfoItem: View {
    let icon: String
    let value: String
    
    var body: some View {
        HStack {
            Image(icon)
                .foregroundColor(.white)
            Text(value)
                .foregroundColor(.white)
                .font(.headline)
        }
    }
}
