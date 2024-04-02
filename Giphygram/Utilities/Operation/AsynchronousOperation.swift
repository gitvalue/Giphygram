import Foundation

/// Ad-hoc asyncronous operation
final class AsynchronousOperation: BaseOperation {
    
    // MARK: - Properties
    
    /// Asyncrhonous task to perform
    var task: (() -> ())? = nil
    
    // MARK: - Public
    
    override func start() {
        super.start()

        if isCancelled {
            finish()
        } else {
            task?()
        }
    }
}
