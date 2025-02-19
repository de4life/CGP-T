
import Foundation
import SwiftUI

struct SplashScreenView: View {
    
    @State private var isActive = false
    @ObservedObject var contentViewModel: WeatherViewModel
    
    var body: some View {
        NavigationStack {
            if isActive {
                MainScreenView(contentViewModel: contentViewModel)
            } else {
                makeSplashScreen()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            isActive = true
                        }
                    }
            }
        }
    }
    
    private func makeSplashScreen() -> some View {
        VStack {
            makeTopView()
            makeMiddleView()
        }
    }
    
    private func makeTopView() -> some View {
        HStack {
            Text("W")
                .foregroundColor(.red)
                .font(.custom("Inter-ExtraBold", size: 96))
            VStack(alignment: .leading, spacing: -5) {
                Text("weather")
                    .font(.custom("Inter-Medium", size: 28))
                    .foregroundColor(.black)
                
                Text("App")
                    .font(.custom("Inter-Medium", size: 28))
                    .foregroundColor(.gray)
                    .padding(.top, 5)
            }
        }
    }
    
    private func makeMiddleView() -> some View {
        VStack {
            Image("mainscreen")
                .resizable()
                .scaledToFit()
                .frame(width: 284, height: 207)
        }
    }
}
