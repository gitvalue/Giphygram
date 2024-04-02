import Foundation

/// Property wrapper for making property atomic
@propertyWrapper final class Atomic<Value> {
    
    // MARK: - Properties
    
    var wrappedValue: Value {
        set {
            isolationQueue.async(flags: .barrier) {
                self.value = newValue
            }
        }
        get {
            var result: Value!
            
            isolationQueue.sync {
                result = self.value
            }
            
            return result
        }
    }
    
    private var value: Value
    private let isolationQueue = DispatchQueue(
        label: "com.oldnmad.Giphygram.Atomic.\(UUID().uuidString)",
        attributes: .concurrent
    )
    
    // MARK: - Initialisers
    
    init(wrappedValue: Value) {
        value = wrappedValue
    }
}
