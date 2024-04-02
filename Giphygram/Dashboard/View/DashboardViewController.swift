import Combine
import UIKit

/// Dashboard screen view controller
final class DashboardViewController: UIViewController {
    
    // MARK: - Model
    
    private typealias CellModel = DashboardViewModel.SearchResultCellModel
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, CellModel>
    private typealias SearchResultCellRegistration = UICollectionView.CellRegistration<DashboardSearchResultCell, CellModel>
    private typealias SearchResultsHeaderRegistration = UICollectionView.SupplementaryRegistration<DashboardSearchResultsSectionHeaderView>
    
    // MARK: - Events publishers
    
    private let collectionViewDidSelectCellEvent = PassthroughSubject<CellModel, Never>()
    private let scrollDidReachBottomEvent = PassthroughSubject<Void, Never>()
    private let searchBarTextDidBeginEditingEvent = PassthroughSubject<Void, Never>()
    private let searchBarTextDidChangeEvent = PassthroughSubject<String, Never>()
    private let searchBarCancelButtonClickedEvent = PassthroughSubject<Void, Never>()
    private let searchBarSearchButtonClickedEvent = PassthroughSubject<Void, Never>()
    private let searchBarTextDidEndEditingEvent = PassthroughSubject<Void, Never>()
    
    // MARK: - Properties
    
    private let searchBar = UISearchBar()
    private let refreshGapInRows: Int = 2
    
    private let detailsView: GifDetailsView
    
    private lazy var dataSource: DataSource = createDataSource()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private let sectionHeaderElementKind = "sectionHeaderElementKind"
    
    private var subscriptions: [AnyCancellable] = []
    private let viewModel: DashboardViewModel
    
    // MARK: - Initialisers
    
    /// Designated initialiser
    /// - Parameters:
    ///   - viewModel: View model
    ///   - detailsViewModel: GIF details view model
    init(viewModel: DashboardViewModel, detailsViewModel: GifDetailsViewModelProtocol) {
        self.viewModel = viewModel
        self.detailsView = GifDetailsView(viewModel: detailsViewModel)
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
        setUpBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Private
    
    private func setUpSubviews() {
        view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.placeholder = viewModel.searchBarPlacehloder
        searchBar.returnKeyType = .done
        searchBar.enablesReturnKeyAutomatically = false
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.keyboardDismissMode = .onDrag
        
        view.addSubview(detailsView)
    }
    
    private func setUpConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        detailsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailsView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            detailsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detailsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setUpBindings() {
        viewModel.subscribeToScrolledToBottomEvent(scrollDidReachBottomEvent.eraseToAnyPublisher())
        viewModel.subscribeToSearchBarDidBeginEditingEvent(searchBarTextDidBeginEditingEvent.eraseToAnyPublisher())
        viewModel.subscribeToSearchBarTextDidChangeEvent(searchBarTextDidChangeEvent.eraseToAnyPublisher())
        viewModel.subscribeToSearchBarCancelButtonClickedEvent(searchBarCancelButtonClickedEvent.eraseToAnyPublisher())
        viewModel.subscribeToSearchBarSearchButtonClickedEvent(searchBarSearchButtonClickedEvent.eraseToAnyPublisher())
        viewModel.subscribeToCellPressedEvent(collectionViewDidSelectCellEvent.eraseToAnyPublisher())
        viewModel.subscribeToSearchBarTextDidEndEditingEvent(searchBarTextDidEndEditingEvent.eraseToAnyPublisher())
        
        subscriptions = [
            viewModel.alertEvent.receive(on: DispatchQueue.main).sink { [weak self] model in
                self?.showAlert(model.title, model.mesage, model.action)
            },
            viewModel.$isSearchBarCancelButtonVisible.receive(on: DispatchQueue.main).sink { [searchBar] isVisible in
                searchBar.setShowsCancelButton(isVisible, animated: true)
            },
            viewModel.endSearchBarEditingEvent.receive(on: DispatchQueue.main).sink { [searchBar] _ in
                searchBar.resignFirstResponder()
            },
            viewModel.reloadEvent.receive(on: DispatchQueue.main).sink { [collectionView] in
                collectionView.reloadData()
            },
            viewModel.$areDetailsHidden.receive(on: DispatchQueue.main).sink { [detailsView] isHidden in
                detailsView.isHidden = isHidden
            },
            viewModel.$areSearchResultsHidden.receive(on: DispatchQueue.main).sink { [collectionView] isHidden in
                collectionView.isHidden = isHidden
            },
            viewModel.$searchResults.receive(on: DispatchQueue.main).sink { [dataSource] results in
                var snapshot = NSDiffableDataSourceSnapshot<Int, CellModel>()
                snapshot.appendSections([0])
                snapshot.appendItems(results, toSection: 0)

                dataSource.apply(snapshot)
            }
        ]
    }
    
    private func createDataSource() -> DataSource {
        let cellRegistration = SearchResultCellRegistration { cell, indexPath, itemIdentifier in
            if let image = itemIdentifier.image{
                cell.setImage(image)
            }
            
            cell.setIsActivityIndicatorActive(itemIdentifier.isActivityIndicatorActive)
        }
        
        let result = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        let headerRegistration = SearchResultsHeaderRegistration(
            elementKind: sectionHeaderElementKind
        ) { [title = viewModel.searchResultsSectionHeader] header, _, _ in
            header.setTitle(title)
        }
        
        result.supplementaryViewProvider = { view, _, index in
            return view.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
        
        return result
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.33),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(0.33)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 3)
        
        let spacing: CGFloat = 10.0
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(78.3)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: sectionHeaderElementKind, 
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]

        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func showAlert(_ title: String, _ message: String, _ dismissButtonTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: dismissButtonTitle, style: .default))
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UISearchBarDelegate

extension DashboardViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBarTextDidBeginEditingEvent.send()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarTextDidChangeEvent.send(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarCancelButtonClickedEvent.send()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarSearchButtonClickedEvent.send()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBarTextDidEndEditingEvent.send()
    }
}

// MARK: - UICollectionViewDelegate

extension DashboardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = dataSource.itemIdentifier(for: indexPath) {
            collectionViewDidSelectCellEvent.send(item)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let lastVisibleCell = collectionView.visibleCells.last else { return }
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        let refreshGap = CGFloat(refreshGapInRows) * lastVisibleCell.bounds.height
        
        if maximumOffset - currentOffset <= refreshGap, 0 < currentOffset, 0 < maximumOffset {
            scrollDidReachBottomEvent.send()
        }
    }
}
