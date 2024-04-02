import Foundation

/// GIF details rating model
struct GifDetailsRatingModel {
    
    // MARK: - Model
    
    enum Style {
        case harmless
        case neutral
        case warning
        case accent
    }
    
    // MARK: - Properties
    
    /// Rating title text
    let title: String
    /// Rating background view style
    let style: Style
}
