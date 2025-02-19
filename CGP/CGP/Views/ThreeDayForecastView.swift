

import Foundation
import SwiftUI

struct ThreeDayForecastView: View {
    let forecastItems: [ForecastResponse.ForecastItem]
    
    private var dailyForecast: [(String, String, Int, Int)] {
        let grouped = Dictionary(grouping: forecastItems) { formatToDay($0.dt) }
        
        return grouped.keys.sorted().prefix(3).compactMap { day in
            guard let dayForecasts = grouped[day], let firstForecast = dayForecasts.first else { return nil }
            let temps = dayForecasts.map { $0.main.temp }
            let minTemp = Int(temps.min() ?? 0)
            let maxTemp = Int(temps.max() ?? 0)
            let icon = firstForecast.weather.first?.icon ?? "01d" 
            
            return (day, icon, minTemp, maxTemp)
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0, green: 0.063, blue: 0.149).opacity(0.4))
                .frame(height: 200)
                .padding(.horizontal)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Next Forecast")
                        .foregroundColor(.white)
                        .font(.headline)
                    Spacer()
                }
                .padding([.leading, .trailing], 30)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 20)
                
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(dailyForecast, id: \.0) { (day, icon, minTemp, maxTemp) in
                        HStack {
                            Text(day)
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 100, alignment: .leading)
                            
                            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 40, height: 40)
                            
                            Spacer()
                            
                            Text("\(maxTemp)° - \(minTemp)°")
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func formatToDay(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
}
