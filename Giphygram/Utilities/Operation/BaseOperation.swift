import Foundation

/// Base operation class. Incapsulates proper state change logic.
open class BaseOperation: Operation {
    
    // MARK: - Properties
    
    open override var isExecuting: Bool { isRunning }
    open override var isFinished: Bool { isDone }
    open override var isAsynchronous: Bool { true }
    
    open var isRunning = false {
        willSet {
            willChangeValue(for: \.isExecuting)
        }
        didSet {
            didChangeValue(for: \.isExecuting)
        }
    }
    
    open var isDone = false {
        willSet {
            willChangeValue(for: \.isFinished)
        }
        didSet {
            didChangeValue(for: \.isFinished)
        }
    }
    
    // MARK: - Public
    
    open override func start() {
        if isCancelled {
            finish()
        } else {
            isRunning = true
        }
    }
    
    open override func cancel() {
        super.cancel()
        finish()
    }
    
    func finish() {
        isRunning = false
        isDone = true
    }
}
