

import SwiftUI

@main
struct CGPApp: App {
    
    @StateObject var contentViewModel = WeatherViewModel()
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView(contentViewModel: contentViewModel)
                .environmentObject(contentViewModel)
        }
    }
}
