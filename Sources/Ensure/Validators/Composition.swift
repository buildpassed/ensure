/// `A && B`
public struct _And<A, B> : Validator
where A: Validator, B: Validator, A.Value == B.Value {
    public static func validate(_ value: A.Value) throws {
        try A.validate(value)
        try B.validate(value)
    }
}

/// `A || B`
public struct _Or<A, B> : Validator
where A: Validator, B: Validator, A.Value == B.Value {
    public static func validate(_ value: A.Value) throws {
        do {
            try A.validate(value)
            return
        } catch {}
        try B.validate(value)
    }
}

public extension Validator {
    /// `Self && Other`
    typealias And<Other> = _And<Self, Other> where Other: Validator, Other.Value == Self.Value
    /// `Self || Other`
    typealias Or<Other> = _Or<Self, Other> where Other: Validator, Other.Value == Self.Value
}

/// `!V`
public struct Not<V> : Validator where V: Validator {
    public static func validate(_ value: V.Value) throws {
        do {
            try V.validate(value)
        } catch {
            return
        }
        throw ValidationError("must not be \(value)")
    }
}
