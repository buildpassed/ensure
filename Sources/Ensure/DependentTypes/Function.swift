public protocol Function2To1 {
    associatedtype A0
    associatedtype A1
    associatedtype R0
    static func perform(_ a0: A0, _ a1: A1) throws -> R0
}

public enum Operator {
    public enum Add<Value>: Function2To1 where Value: AdditiveArithmetic {
        public static func perform(_ a: Value, _ b: Value) throws -> Value {
            a + b
        }
    }
    
    public enum Subtract<Value>: Function2To1 where Value: AdditiveArithmetic {
        public static func perform(_ a: Value, _ b: Value) throws -> Value {
            a - b
        }
    }
}
