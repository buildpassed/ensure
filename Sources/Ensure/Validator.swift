import Foundation

/// A type that validates a value.
public protocol Validator {
    associatedtype Value
    static func validate(_ value: Value) throws
}

public struct ValidationError : LocalizedError {
    let message: String
    
    public init(_ message: String) {
        self.message = message
    }
    
    public var errorDescription: String? {
        message
    }
}
