import UIKit

/// `UIImage` extension methods
extension UIImage {
    /// Creates animated `UIImage` from GIF data
    /// - Parameter data: GIF binary data
    /// - Returns: Animated image object
    static func animatedImage(withData data: Data) -> UIImage? {
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        
        let framesCount = CGImageSourceGetCount(imageSource)
        
        var frames: [UIImage] = []
        var delays: [Double] = []
        
        for i in 0..<framesCount {
            if let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) {
                if let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) as? [String: Any],
                   let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any],
                   let delayTime = gifProperties[kCGImagePropertyGIFDelayTime as String] as? Double {
                    delays.append(delayTime)
                }
                
                let frame = UIImage(cgImage: cgImage)
                frames.append(frame)
            }
        }
        
        return .animatedImage(with: frames, duration: delays.reduce(0, +))
    }
}
