
import Foundation
import SwiftUI

struct ForecastItemView: View {
    let forecast: ForecastResponse.ForecastItem
    
    var body: some View {
       
            VStack {
                Text("\(Int(forecast.main.temp))°C")
                    .foregroundColor(.white)
                    .font(.headline)
                
                
                AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(forecast.weather.first?.icon ?? "01d")@2x.png")) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 24, height: 24)
                
                Text(formatDate(forecast.dt))
                    .foregroundColor(.white)
                    .font(.caption)
                
            }
            .frame(width: 80, height: 140)
            .background(.clear)
            .cornerRadius(10)
            .shadow(radius: 3)
        
    }
    
    private func formatDate(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

struct ForecastListView: View {
    let forecastItems: [ForecastResponse.ForecastItem]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0, green: 0.063, blue: 0.149).opacity(0.4))
                .frame(height: 180)
                .padding(.horizontal)
            VStack(alignment: .leading) {
                
                HStack {
                    Text("Today")
                        .foregroundColor(.white)
                        .font(.headline)
                    Spacer()
                    Text(formattedDate())
                        .foregroundColor(.white)
                        .font(.subheadline)
                }
                .padding([.leading, .trailing], 40)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 5) {
                        ForEach(forecastItems.prefix(5), id: \.dt) { item in
                            ForecastItemView(forecast: item)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal)
            }
        }
    }
    private func formattedDate() -> String {
           let formatter = DateFormatter()
           formatter.dateFormat = "MMM d"
           return formatter.string(from: Date())
       }
        
}
