import Foundation

/// `GifService` error model
struct GifServiceError: Error {
    /// Response status model
    let code: GifResponseStatusDto
}
