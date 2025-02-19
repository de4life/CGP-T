

import Foundation
import SwiftUI


struct MainScreenView: View {
    
    @ObservedObject var contentViewModel: WeatherViewModel
    
    @State private var locationText: String = "Get current location"
    @State private var searchText: String = ""
    @State private var navigateToSearchResult = false
    
    var body: some View {
        NavigationStack {
            makeMainScreen()
        }
        .alert(isPresented: $contentViewModel.showAlert) {
            Alert(title: Text("Error"),
                  message: Text(contentViewModel.alertMessage),
                  dismissButton: .default(Text("ОК")))
        }
        .onChange(of: contentViewModel.canNavigate) { canNavigate in
            if canNavigate {
                navigateToSearchResult = true 
            }
        }
        .navigationDestination(isPresented: $contentViewModel.canNavigate) {
            SearchResult(contentViewModel: contentViewModel)
        }
    }
    
    private func makeMainScreen() -> some View {
        VStack {
            makeTopView()
            Spacer()
            makeMiddleView()
            Spacer()
            makeBottomView()
            Spacer()
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
    
    private func makeBottomView() -> some View {
        VStack(spacing: 16) {
            HStack {
                TextField("", text: $locationText)
                    .disabled(true)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(20)
                
                Button(action: {
                    contentViewModel.updateLocation()
                    navigateToSearchResult = true
                }) {
                    Text("check")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(red: 0.031, green: 0.141, blue: 0.31))
                        .cornerRadius(20)
                }
            }
            
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Enter city name", text: $searchText)
                        .padding(.leading, 5)
                        .textInputAutocapitalization(.never)
                }
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(20)
                
                Button(action: {
                    if !searchText.isEmpty {
                        contentViewModel.fetchWeather(for: searchText)
                        searchText = ""
                        
                    }
                }) {
                    Text("check")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(red: 0.031, green: 0.141, blue: 0.31))
                        .cornerRadius(20)
                }
            }
        }
        .padding([.leading, .trailing], 40)
    }
    
}


