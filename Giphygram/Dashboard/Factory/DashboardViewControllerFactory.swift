import UIKit

/// Dashboard screen factory
final class DashboardViewControllerFactory {
    /// Creates dashboard screen
    /// - Returns: Dashboard view controller
    func create() -> UIViewController {
        let router = DashboardRouter()
        let service = GifService { UrlRestApiRequester(apiUrl: $0) }
        let detailsRouter = GifDetailsRouter()
        let detailsViewModel = DashboardGifDetailsViewModel(service: service, router: detailsRouter)
        let viewModel = DashboardViewModel(
            router: router,
            service: service,
            imageLoaderConstructor: { GifLoader(countLimit: $0) },
            detailsViewModel: detailsViewModel
        )
        
        let result = DashboardViewController(viewModel: viewModel, detailsViewModel: detailsViewModel)
        router.setRootViewController(result)
        detailsRouter.setRootViewController(result)
        
        return result
    }
}
