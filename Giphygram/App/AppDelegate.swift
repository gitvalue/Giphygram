import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow? = nil
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow()
        let factory = DashboardViewControllerFactory()
        window?.rootViewController = UINavigationController(rootViewController: factory.create())
        window?.makeKeyAndVisible()
        
        return true
    }
}
