import UIKit

final class DashboardSearchResultsSectionHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    
    override var reuseIdentifier: String? { String(describing: self) }
    
    private let label = UILabel()
    
    // MARK: - Initialisers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpSubviews()
        setUpConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    func setTitle(_ text: String) {
        label.text = text
    }
    
    // MARK: - Private
    
    private func setUpSubviews() {
        addSubview(label)
        label.font = .systemFont(ofSize: 32.0)
    }
    
    private func setUpConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 20.0),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20.0)
        ])
    }
}
