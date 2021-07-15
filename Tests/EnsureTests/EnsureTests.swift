import XCTest
@testable import Ensure

final class EnsureTests: XCTestCase {
    private func _ensure<V: Validator>(_: V.Type = V.self, success: V.Value, failure: V.Value) {
        XCTAssertNoThrow(try Ensure<V>(wrappedValue: success))
        XCTAssertThrowsError(try Ensure<V>(wrappedValue: failure))
    }
    
    func testComparison() {
        _ensure(EqualTo<Int._5>.self, success: 5, failure: 6)
        _ensure(GreaterThanOrEqualTo<Int._5>.self, success: 10, failure: 0)
    }
    
    func testCollections() {
        _ensure(Not<Array<String>.IsEmpty>.self, success: ["Hello, world!"], failure: [])
        _ensure(Not<String.IsEmpty>.And<String.Contains<Character.Space>>.self, success: "Hello, world!", failure: "Hello,world!")
        _ensure(Array<Int>.AllSatisfy<GreaterThan<Int._5>>.self, success: [6, 7, 8], failure: [6, 7, 3])
        _ensure(Array<String>.AllSatisfy<String.Contains<Character.Space>.Or<String.Contains<Character.NewLine>>>.self, success: [" ", "\n"], failure: ["A", "B"])
        _ensure(Array<String>.ContainsWhere<EqualTo<String.Space>>.self, success: [" ", "\n"], failure: ["A", "B"])
        _ensure(Array<String>.Mapped<String.Count, Array<Int>.Reduced<Int._0, Operator.Add<Int>, GreaterThan<Int._5>>>.self, success: ["123", "456"], failure: ["1", "2", "3"])
        _ensure(Array<Int>.Reduced<Int._0, Operator.Add<Int>, GreaterThan<Int._5>>.self, success: [3, 3], failure: [3, 2])
    }
    
    func testTypes() {
        _ensure(Is<Int>.self, success: 123, failure: 123.0)
    }
}
