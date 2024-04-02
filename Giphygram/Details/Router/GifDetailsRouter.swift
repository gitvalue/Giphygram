import SafariServices

/// GIF details navigation manager interface
/// sourcery: AutoMockable
protocol GifDetailsRouterProtocol: AnyObject {
    /// Opens URL in browser
    /// - Parameter url: URL
    func openUrl(_ url: URL)
}

/// GIF details navigation manager
final class GifDetailsRouter: GifDetailsRouterProtocol {
    
    // MARK: - Properties
    
    private weak var rootViewController: UIViewController?
    
    // MARK: - Public
    
    /// Assigns root view controller, from which navigation starts
    /// - Parameter viewController: Root view controller
    func setRootViewController(_ viewController: UIViewController) {
        rootViewController = viewController
    }
    
    func openUrl(_ url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        rootViewController?.present(safariViewController, animated: true)
    }
}
