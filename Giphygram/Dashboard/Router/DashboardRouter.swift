import UIKit

/// Dashboard screen navigation manager interface
/// sourcery: AutoMockable
protocol DashboardRouterProtocol: AnyObject {
    /// Opens gif details screen
    /// - Parameter details: Gif details model
    func openDetails(_ details: GifDetails)
}

/// Dashboard screen navigation manager
final class DashboardRouter: DashboardRouterProtocol {
    
    // MARK: - Properties
    
    private weak var presentingViewController: UIViewController?
    
    // MARK: - Public
    
    /// Assigns root view controller, from which navigation starts
    /// - Parameter viewController: Root view controller
    func setRootViewController(_ viewController: UIViewController) {
        presentingViewController = viewController
    }
    
    func openDetails(_ details: GifDetails) {
        let factory = GifDetailsViewControllerFactory()
        let viewController = factory.create(withDetails: details)
        presentingViewController?.present(viewController: viewController, animated: true, pushIfPossible: true)
    }
}
