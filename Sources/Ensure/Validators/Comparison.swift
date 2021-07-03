/// `== DependentValue`
public struct EqualTo<DependentValue> : Validator
where DependentValue: DependentType, DependentValue.Value: Equatable {
    public static func validate(_ value: DependentValue.Value) throws {
        guard value == DependentValue.value else { throw ValidationError("must equal \(DependentValue.value)") }
    }
}

/// `< DependentValue`
public struct LessThan<DependentValue> : Validator
where DependentValue: DependentType, DependentValue.Value: Comparable {
    public static func validate(_ value: DependentValue.Value) throws {
        guard value < DependentValue.value else { throw ValidationError("must be less than \(DependentValue.value)") }
    }
}

/// `> DependentValue`
public struct GreaterThan<DependentValue> : Validator
where DependentValue: DependentType, DependentValue.Value: Comparable {
    public static func validate(_ value: DependentValue.Value) throws {
        guard value > DependentValue.value else { throw ValidationError("must be greater than \(DependentValue.value)") }
    }
}

/// `<= DependentValue`
public typealias LessThanOrEqualTo<DependentValue> = LessThan<DependentValue>.Or<EqualTo<DependentValue>> where DependentValue: DependentType, DependentValue.Value: Comparable & Equatable
/// `>= DependentValue`
public typealias GreaterThanOrEqualTo<DependentValue> = GreaterThan<DependentValue>.Or<EqualTo<DependentValue>> where DependentValue: DependentType, DependentValue.Value: Comparable & Equatable
