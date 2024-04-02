import Combine
import UIKit

/// Dashboard search result cell view
final class DashboardSearchResultCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let imageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Initialisers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        activityIndicator.stopAnimating()
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    func setIsActivityIndicatorActive(_ isActive: Bool) {
        if isActive {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Private
    
    private func setupSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: contentView.topAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
