import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var coordinator: AppCoordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else { return true }
        window.overrideUserInterfaceStyle = .dark

        coordinator = AppCoordinator(window: window)
        coordinator?.start()
        return true
    }
}

