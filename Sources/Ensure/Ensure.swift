/// Validates a value on initialization, then provides access to all its properties.
@propertyWrapper
@dynamicMemberLookup
public struct Ensure<V> where V: Validator {
    public let wrappedValue: V.Value
    
    public init(wrappedValue: V.Value) throws {
        try V.validate(wrappedValue)
        self.wrappedValue = wrappedValue
    }
    
    public subscript<T>(dynamicMember member: KeyPath<V.Value, T>) -> T {
        wrappedValue[keyPath: member]
    }
}
