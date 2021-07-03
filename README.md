# Ensure

> Type-based input validation

```swift
try Ensure<PackageIsCool>(wrappedValue: packages.ensure)
```

## Validators

A `Validator` is a type that validates an input. You can create a `Validator` like so:
```swift
struct GreaterThanZero : Validator {
  static func validate(_ value: Int) throws {
    guard value > 0 else { throw ValidationError("must be > 0") }
  }
}
```

There are tons of [built-in validators](#built-in-validators). You can combine them using various operations:
```swift
Not<EqualTo<Int._5>>.And<GreaterThanZero>
```

## Dependent Types

A `DependentType` is a type that represents a value. Several are provided for some builtin types:
```swift
Int._0 // 0
Double._10 // 10
String.Space // " "
Bool.True // true
```
You can create a custom `DependentType` by implementing the protocol:
```swift
extension String {
  enum HelloWorld : DependentType {
    public static let value: String = "Hello, world!"
  }
}
```

## Built-in Validators

* [Composition](#composition)
* [Comparison](#comparison)
* [Collections](#collections)

### Composition
#### `And`
```swift
// value > 0 && value < 5
GreaterThan<Int._0>.And<LessThan<Int._5>>
```
#### `Or`
```swift
// value < 0 || value > 5
LessThan<Int._0>.Or<GreaterThan<Int._5>>
```
#### `Not`
```swift
Not<EqualTo<Int._0>> // value != 0
```

### Comparison
#### `EqualTo`
```swift
EqualTo<Int._5> // == 5
EqualTo<String.HelloWorld> // == "Hello, world!"
```
#### `LessThan`
```swift
LessThan<Int._5> // < 5
```
#### `GreaterThan`
```swift
GreaterThan<Int._5> // > 5
```
#### `LessThanOrEqualTo`
```swift
LessThanOrEqualTo<Int._5> // <= 5
```
#### `GreaterThanOrEqualTo`
```swift
GreaterThanOrEqualTo<Int._5> // >= 5
```

### Collections
#### `Collection.[CountIs|Count]`
```swift
// [String].count > 5
Array<String>.CountIs<GreaterThan<Int._5>>
// [String].map(\.count).contains(5)
Array<String>.Mapped<Array<Int>.Count, Array<Int>.Contains<Int._5>>
```
#### `Collection.IsEmpty`
```swift
Not<String.IsEmpty> // !String.isEmpty
```
#### `Collection.[Contains|ContainsWhere]`
```swift
// [String].contains("Hello, world!")
Array<String>.Contains<String.HelloWorld>
// [String].contains(where: { $0.count > 0 })
Array<String>.ContainsWhere<String.CountIs<GreaterThan<Int._0>>>
```
#### `Collection.AllSatisfy`
```swift
// [String].allSatisfy { $0.count > 0 }
Array<String>.AllSatisfy<String.CountIs<GreaterThan<Int._0>>>
```
#### `Collection.Mapped`
```swift
// [String].map(\.count).contains(5)
Array<String>.Mapped<Array<Int>.Count, Array<Int>.Contains<Int._5>>
```
#### `Collection.Reduced`
```swift
// [Int].reduce(0, +) > 5
Array<Int>.Reduced<Int._0, Operator.Add, GreaterThan<Int._5>>
```
