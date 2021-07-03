/// Converts the input type to the output type.
public protocol MapValidator {
    associatedtype Value
    associatedtype Output
    static func convert(_ input: Value) throws -> Output
}

public struct _ValidateMappedValue<Map, V> : Validator where Map: MapValidator, V: Validator, V.Value == Map.Output {
    public static func validate(_ value: Map.Value) throws {
        try V.validate(Map.convert(value))
    }
}

extension MapValidator {
    public typealias Ensure<V> = _ValidateMappedValue<Self, V> where V: Validator, V.Value == Self.Output
}
