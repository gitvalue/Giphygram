import UIKit

/// GIF details screen factory
final class GifDetailsViewControllerFactory {
    /// Creates GIF details view controller
    /// - Parameter details: GIF details model
    /// - Returns: GIF details view controller
    func create(withDetails details: GifDetails) -> UIViewController {
        let router = GifDetailsRouter()
        let viewModel = GifDetailsViewModel(details: details, router: router)
        let viewController = GifDetailsViewController(viewModel: viewModel)
        router.setRootViewController(viewController)
        
        return viewController
    }
}
