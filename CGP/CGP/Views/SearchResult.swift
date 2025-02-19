
import Foundation
import SwiftUI

struct SearchResult: View {
    
    @ObservedObject  var contentViewModel: WeatherViewModel
    @State private var isDailyForecast = false
    
    var body: some View {
        makeResults()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.031, green: 0.141, blue: 0.31),
                        Color(red: 0.075, green: 0.298, blue: 0.71),
                        Color(red: 0.043, green: 0.259, blue: 0.671)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea(.all)
            )
    }
    
    private func makeResults() -> some View {
        VStack {
            makeTopView()
            makeMiddleView()
            makeBottomView()
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func makeTopView() -> some View {
        HStack {
            Image("locations")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            Text(contentViewModel.cityName)
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.leading, 20)
    }
    
    private func makeMiddleView() -> some View {
        VStack {
            Image("mainscreen")
                .resizable()
                .scaledToFit()
                .frame(width: 284, height: 207)
            VStack {
                if let weather = contentViewModel.weather {
                    Text("\(Int(weather.main.temp))°")
                        .font(.system(size: 64, weight: .bold))
                        .foregroundColor(.white)
                }
                Text("Precipitations")
                    .foregroundColor(.white)
                Text("Max.: \(Int(contentViewModel.weather?.main.temp_max ?? 0))°  Min.: \(Int(contentViewModel.weather?.main.temp_min ?? 0))°")
                    .foregroundColor(.white)
                ZStack {
                    WeatherInfoView(contentViewModel: contentViewModel)
                }
            }
        }
    }
    
    private func makeBottomView() -> some View {
            VStack {
                if isDailyForecast {
                    ThreeDayForecastView(forecastItems: contentViewModel.forecast)
                } else {
                    ForecastListView(forecastItems: contentViewModel.forecast)
                }
                
                Button(action: {
                    isDailyForecast.toggle()
                }) {
                    Text(isDailyForecast ? "Home" : "Next Forecast")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding(.horizontal)
            }
        }
}

