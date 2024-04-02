import UIKit

/// Image loader interface
/// sourcery: AutoMockable
protocol ImageLoading: AnyObject {
    /// Fetches remote image data
    /// - Parameters:
    ///   - url: Remote image URL
    ///   - completion: Fetching completion
    func fetchImage(_ url: URL, _ completion: @escaping (Result<(UIImage, Data), Error>) -> ())
    
    /// Gets cached image data
    /// - Parameter url: Image URL
    /// - Returns: Cached image data, if exists
    func imageData(forUrl url: URL) -> Data?
    
    /// Gets cached image object
    /// - Parameter url: Image URL
    /// - Returns: Cached image object, if exists
    func image(forUrl url: URL) -> UIImage?
}
