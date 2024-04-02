import UIKit

/// UIViewController extension methods
extension UIViewController {
    /// Presents view controller from current view controller
    /// - Parameters:
    ///   - viewController: View controller to present
    ///   - animated: Controls if view controller needs to be presented animated
    ///   - pushIfPossible: Controls if view controller needs to be pushed to navigation stack (if exists)
    ///   - completion: Presentation completion
    func present(
        viewController: UIViewController,
        animated: Bool,
        pushIfPossible: Bool,
        completion: (() -> ())? = nil
    ) {
        let navigationController = [self as? UINavigationController, navigationController].compactMap { $0 }.first
        
        if pushIfPossible, let navigationController {
            navigationController.pushViewController(viewController, animated: animated)
            completion?()
        } else {
            present(viewController, animated: animated, completion: completion)
        }
    }
}
