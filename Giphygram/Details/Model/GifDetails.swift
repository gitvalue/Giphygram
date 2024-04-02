import Foundation

/// GIF details model
struct GifDetails: Hashable {
    /// GIF binary data
    let data: Data
    /// GIF title text
    let title: String
    /// GIF webpage URL
    let url: URL
    /// Content rating identifier
    let rating: String
}
