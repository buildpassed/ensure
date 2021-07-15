/// `is TargetType`
public struct Is<TargetType>: Validator {
    public static func validate(_ value: Any) throws {
        guard (value as? TargetType) != nil
        else { throw ValidationError("must cast to \(TargetType.self)") }
    }
}
