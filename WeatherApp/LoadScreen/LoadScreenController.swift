import Foundation
import UIKit
import CoreLocation

class LoadScreenController: UIViewController {
    
    var viewModel: LoadScreenControllerViewModel?
    var coordinator: AppCoordinator?
    
    
    private let locationManager = CLLocationManager()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        setupUI()
        checkAuthorizationStatus()
        setupLocationManager()
        bind()
    }
    
    private func setupUI() {
        let spinner = UIActivityIndicatorView(style: .large)
        let background = UIImageView(image: UIImage(named: "weatherLaunch"))
        [background, spinner].forEach { view.addSubview($0) }
        
        spinner.startAnimating()
        spinner.color = .systemPink
        spinner.centerX(inView: view)
        spinner.centerY(inView: view)
        
        background.contentMode = .scaleAspectFill
        background.anchor(top: view.topAnchor,
                          bottom: view.bottomAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor)
        
    }
    
    private func bind() {
        viewModel?.currentLocationForecast.addListener { [weak self] forecast in
            self?.showNextModule(with: forecast)
        }
    }
    
    private func checkAuthorizationStatus() {
        if locationManager.authorizationStatus == .denied { showNextModule(with: nil) }
    }
    
    private func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    private func showNextModule(with currentLocationForecast: Forecast?) {
        coordinator?.toMainModule(with: currentLocationForecast)
    }
}

extension LoadScreenController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorizationStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        guard let location = manager.location else { return }
        viewModel?.didGet(location: location)
    }
}
