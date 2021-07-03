/// Do not use this directly. Use `Collection.Count`
public struct _Count<Value> : MapValidator where Value: Collection {
    public static func convert(_ input: Value) throws -> Int {
        input.count
    }
}

/// Do not use this directly. Use `Collection.Mapped`
public struct _Mapped<Value, MapF> : MapValidator
where Value: Collection, MapF: MapValidator, MapF.Value == Value.Element {
    public static func convert(_ input: Value) throws -> [MapF.Output] {
        try input.map(MapF.convert)
    }
}

/// Do not use this directly. Use `Collection.Reduced`
public struct _Reduced<Value, InitialResult, Reducer> : MapValidator
where Value: Collection,
      InitialResult: DependentType, InitialResult.Value == Reducer.R0,
      Reducer: Function2To1, Reducer.A0 == Reducer.R0, Reducer.A1 == Value.Element
{
    public static func convert(_ input: Value) throws -> Reducer.R0 {
        try input.reduce(InitialResult.value, Reducer.perform)
    }
}

/// Do not use this directly. Use `Collection.IsEmpty`
public struct _IsEmpty<Value> : Validator where Value: Collection {
    public static func validate(_ value: Value) throws {
        guard value.isEmpty else { throw ValidationError("must be empty") }
    }
}

/// Do not use this directly. Use `Collection.ContainsWhere`
public struct _ContainsWhere<Value, Condition>: Validator where Value: Collection, Condition: Validator, Condition.Value == Value.Element {
    public static func validate(_ input: Value) throws {
        guard input.contains(where: { (try? Condition.validate($0)) != nil }) else { throw ValidationError("must contain a matching value") }
    }
}

/// Do not use this directly. Use `Collection.Contains`
public struct _Contains<Value, Element>: Validator where Value: Collection, Value.Element: Equatable, Element: DependentType, Element.Value == Value.Element {
    public static func validate(_ input: Value) throws {
        guard input.contains(Element.value) else { throw ValidationError("must contain \(Element.value)") }
    }
}

/// Do not use this directly. Use `Collection.AllSatisfy`
public struct _AllSatisfy<Value, Condition>: Validator where Value: Collection, Condition: Validator, Condition.Value == Value.Element {
    public static func validate(_ input: Value) throws {
        guard input.allSatisfy({
            (try? Condition.validate($0)) != nil
        }) else { throw ValidationError("must all satisfy constraint") }
    }
}

public extension Collection {
    /// `Collection.count`
    typealias CountIs<V> = _Count<Self>.Ensure<V> where V: Validator, V.Value == Int
    /// `Collection.count`
    typealias Count = _Count<Self>
    /// `Collection.isEmpty`
    typealias IsEmpty = _IsEmpty<Self>
    /// `Collection.contains(where:)`
    typealias ContainsWhere<V> = _ContainsWhere<Self, V> where V: Validator, V.Value == Element
    /// `Collection.allSatisfy`
    typealias AllSatisfy<V> = _AllSatisfy<Self, V> where V: Validator, V.Value == Element
    /// `Collection.map`
    typealias Mapped<MapF, V> = _Mapped<Self, MapF>.Ensure<V>
        where MapF: MapValidator, MapF.Value == Element,
              V: Validator, V.Value == [MapF.Output]
    /// `Collection.reduce`
    typealias Reduced<InitialResult, Reducer, V> = _Reduced<Self, InitialResult, Reducer>.Ensure<V>
        where InitialResult: DependentType, InitialResult.Value == Reducer.R0,
              Reducer: Function2To1, Reducer.A0 == Reducer.R0, Reducer.A1 == Element,
              V: Validator, V.Value == Reducer.R0
}

public extension Collection where Element: Equatable {
    /// Validates `Collection.contains`
    typealias Contains<V> = _Contains<Self, V> where V: DependentType, V.Value == Element, Element: Equatable
}
