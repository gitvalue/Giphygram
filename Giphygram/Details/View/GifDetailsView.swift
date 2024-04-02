import Combine
import UIKit
import WebKit

/// GIF details view
final class GifDetailsView: UIView {
    
    // MARK: - Events publishers
    
    private let urlClickedEvent = PassthroughSubject<URL, Never>()
    
    // MARK: - Properties
    
    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    private let descriptionTitleLabel = UILabel()
    private let descriptionSubtitleTextView = UITextView()
    private let ratingContainerView = UIView()
    private let ratingBackgroundView = UIView()
    private let ratingTitleLabel = UILabel()
    
    private let animationQueue: OperationQueue = .serial
    
    private var subscriptions: [AnyCancellable] = []
    private let viewModel: GifDetailsViewModelProtocol
    
    // MARK: - Initialisers
    
    init(viewModel: GifDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        backgroundColor = .clear
        
        setUpSubviews()
        setUpConstraints()
        setUpBindings()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    override func layoutSubviews() {
        super.layoutSubviews()
        ratingContainerView.layer.cornerRadius = ratingContainerView.frame.width / 2
    }
    
    // MARK: - Private
    
    private func setUpSubviews() {
        addSubview(titleLabel)
        titleLabel.font = .systemFont(ofSize: 32.0)
        titleLabel.text = viewModel.title
        
        addSubview(imageView)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10.0
        imageView.layer.borderColor = UIColor.secondarySystemFill.cgColor
        imageView.layer.borderWidth = 5.0
        
        addSubview(descriptionTitleLabel)
        descriptionTitleLabel.font = .systemFont(ofSize: 24.0, weight: .semibold)
        descriptionTitleLabel.numberOfLines = 0
        
        addSubview(descriptionSubtitleTextView)
        descriptionSubtitleTextView.isEditable = false
        descriptionSubtitleTextView.isSelectable = true
        descriptionSubtitleTextView.isScrollEnabled = false
        descriptionSubtitleTextView.dataDetectorTypes = .link
        descriptionSubtitleTextView.textContainer.lineFragmentPadding = 0
        descriptionSubtitleTextView.textContainerInset = .zero
        descriptionSubtitleTextView.delegate = self
        
        addSubview(ratingContainerView)
        ratingContainerView.clipsToBounds = true
        ratingContainerView.addSubview(ratingBackgroundView)
        ratingContainerView.addSubview(ratingTitleLabel)
        ratingTitleLabel.adjustsFontSizeToFitWidth = true
        ratingTitleLabel.textAlignment = .center
    }
    
    private func setUpConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20.0),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0)
        ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20.0),
            imageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20.0),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        
        descriptionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16.0),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            descriptionTitleLabel.trailingAnchor.constraint(equalTo: ratingContainerView.leadingAnchor, constant: -16.0),
        ])
        
        descriptionSubtitleTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionSubtitleTextView.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 8.0),
            descriptionSubtitleTextView.leadingAnchor.constraint(equalTo: descriptionTitleLabel.leadingAnchor),
            descriptionSubtitleTextView.trailingAnchor.constraint(equalTo: descriptionTitleLabel.trailingAnchor)
        ])
        
        ratingContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ratingContainerView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16.0),
            ratingContainerView.widthAnchor.constraint(equalToConstant: 50.0),
            ratingContainerView.heightAnchor.constraint(equalToConstant: 50.0),
            ratingContainerView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        ])
        
        ratingBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ratingBackgroundView.topAnchor.constraint(equalTo: ratingContainerView.topAnchor),
            ratingBackgroundView.leadingAnchor.constraint(equalTo: ratingContainerView.leadingAnchor),
            ratingBackgroundView.trailingAnchor.constraint(equalTo: ratingContainerView.trailingAnchor),
            ratingBackgroundView.bottomAnchor.constraint(equalTo: ratingContainerView.bottomAnchor)
        ])
        
        ratingTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ratingTitleLabel.centerYAnchor.constraint(equalTo: ratingContainerView.centerYAnchor),
            ratingTitleLabel.leadingAnchor.constraint(equalTo: ratingContainerView.leadingAnchor),
            ratingTitleLabel.trailingAnchor.constraint(equalTo: ratingContainerView.trailingAnchor)
        ])
    }
    
    private func setUpBindings() {
        viewModel.subscribeToUrlClickedEvent(urlClickedEvent.eraseToAnyPublisher())
        
        subscriptions = [
            viewModel.imageData.receive(on: DispatchQueue.main).sink { [imageView] data in
                imageView.image = .animatedImage(withData: data)
            },
            viewModel.descriptionTitle.receive(on: DispatchQueue.main).sink { [descriptionTitleLabel] text in
                descriptionTitleLabel.text = text
            },
            viewModel.descriptionSubtitle.receive(on: DispatchQueue.main).sink { [descriptionSubtitleTextView] text in
                let attributedText = NSMutableAttributedString(attributedString: text)
                attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 18.0), range: NSRange(location: 0, length: text.length))
                descriptionSubtitleTextView.attributedText = attributedText
            },
            viewModel.ratingModel.receive(on: DispatchQueue.main).sink { [weak self] model in
                self?.updateRatingView(model)
            }
        ]
    }
    
    private func updateRatingView(_ model: GifDetailsRatingModel) {
        ratingTitleLabel.text = model.title
        switch model.style {
        case .harmless:
            ratingBackgroundView.backgroundColor = .systemGreen
        case .neutral:
            ratingBackgroundView.backgroundColor = .systemOrange
        case .warning:
            ratingBackgroundView.backgroundColor = .systemPurple
        case .accent:
            ratingBackgroundView.backgroundColor = .systemRed
        }
    }
}

// MARK: - UITextViewDelegate

extension GifDetailsView: UITextViewDelegate {
    func textView(_ textView: UITextView, primaryActionFor textItem: UITextItem, defaultAction: UIAction) -> UIAction? {
        switch textItem.content {
        case .link(let url):
            urlClickedEvent.send(url)
        default:
            break
        }
        
        return nil
    }
}
