import Foundation

/// Abstract additive aggregate operation. Non-overlap friendly.
public protocol SparseTableAdditiveAggregate: SparseTableAggregate {}

public enum SparseTableSumAggregate<T: AdditiveArithmetic>: SparseTableAdditiveAggregate {
    public typealias Element = T
    public static func aggregate(_ lhs: T, _ rhs: T) -> T { lhs + rhs }
    public static var initialElement: Element { T.zero }
}
