import Foundation

/// `OperationQueue` extension methods
extension OperationQueue {
    /// Serial queue
    static var serial: OperationQueue {
        let result = OperationQueue()
        result.maxConcurrentOperationCount = 1
        
        return result
    }
}
