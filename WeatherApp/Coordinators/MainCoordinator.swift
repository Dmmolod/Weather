import Foundation
import UIKit

class MainCoordinator: NSObject, Coordinator {
    
    let window: UIWindow?
    var navController: UINavigationController?

    private let networkManager = NetworkManager()
    private let favouritesManager = FavouritesManager()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start(with currentLocationForecast: Forecast?) {
        let favouritesVC = FavouritesController()
        
        favouritesVC.coordinator = self
        favouritesVC.viewModel = FavouritesViewModel(currentLocationForecast, favouritesManager, networkManager)
        setNavControllerToWindow(with: favouritesVC)
        
        if let currentLocationForecast = currentLocationForecast {
            let weatherVC = WeatherViewController()
            weatherVC.coordinator = self
            weatherVC.viewModel = WeatherViewModel(currentLocationForecast)
            navController?.pushViewController(weatherVC, animated: false)
        }
        
    }
    
    func toFavouritesScreen() {
        navController?.popToRootViewController(animated: true)
    }
    
    func toWeatherScreen(with forecast: Forecast, from indexPath: IndexPath) {
        let weatherScreen = WeatherViewController()
        weatherScreen.coordinator = self
        weatherScreen.viewModel = WeatherViewModel(forecast, indexPath)
        navController?.pushViewController(weatherScreen, animated: true)
    }
    
    func presentWeatherScreen(with cityInfo: CityInfo) {
        let weatherScreen = WeatherViewController()
        weatherScreen.coordinator = self
        if let topViewController = navController?.topViewController as? WeatherViewControllerDelegate {
            weatherScreen.delegate = topViewController
        }
        weatherScreen.viewModel = WeatherViewModel(cityInfo, isPresentationStyle: true)
        navController?.present(weatherScreen, animated: true)
    }
    
    func dismiss(_ controllerToDissmis: UIViewController?,
                 animated: Bool,
                 modalTransitionStyle: UIModalTransitionStyle = .crossDissolve) {
        
        guard let controllerToDissmis = controllerToDissmis else { return }

        controllerToDissmis.modalTransitionStyle = modalTransitionStyle
        controllerToDissmis.dismiss(animated: animated)
    }
    
    private func setNavControllerToWindow(with rootVC: UIViewController) {
        navController = UINavigationController(rootViewController: rootVC)
        navController?.navigationBar.isHidden = true
        navController?.delegate = self
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}

extension MainCoordinator: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let toVC = toVC as? AnimatableTransitionFromTableCell,
           let fromVC = fromVC as? AnimatableTransitionIntoTableCell,
           let indexPath = fromVC.getIndexPath() {
            return AnimationIntoCell(toVC: toVC, animateCellIndexPath: indexPath)
        }
        
        if let fromVC = fromVC as? AnimatableTransitionFromTableCell,
           let indexPath = fromVC.getIndexPath() {
            return AnimationFromCell(fromVC: fromVC, animateCellIndexPath: indexPath)
        }
        
        return nil
    }
}
