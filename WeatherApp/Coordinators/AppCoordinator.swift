import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    var window: UIWindow?
    var navController: UINavigationController?
    
    init(_ window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let startVC = LoadScreenController()
        startVC.viewModel = LoadScreenControllerViewModel()
        startVC.coordinator = self
        
        window?.rootViewController = startVC
        window?.makeKeyAndVisible()
    }
    
    func toMainModule(with currentLocationForecast: Forecast?) {
        guard let window = window else { return }
        MainCoordinator(window: window).start(with: currentLocationForecast)
    }
}
