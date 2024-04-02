import UIKit

/// GIF details screen
final class GifDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let detailsView: GifDetailsView
    
    // MARK: - Initialisers
    
    init(viewModel: GifDetailsViewModelProtocol) {
        detailsView = GifDetailsView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setUpSubviews()
        setUpConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Private
    
    private func setUpSubviews() {
        view.addSubview(detailsView)
    }
    
    private func setUpConstraints() {
        detailsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detailsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
