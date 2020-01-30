import Foundation

/// Abstract *Min*/*Max* aggregate operation. Overlap friendly.
public protocol SparseTableMinMaxAggregate: SparseTableAggregate where Element: Comparable {
    static func qualify(_ lhs: Element, _ rhs: Element) -> Bool
}

/// *Min* aggregate operation. Overlap friendly.

public enum SparseTableMinAggregate<T: Comparable & MaxBounded>: SparseTableMinMaxAggregate {
    public static func qualify(_ lhs: T, _ rhs: T) -> Bool { lhs < rhs }
    public static func aggregate(_ lhs: T, _ rhs: T) -> T { min(lhs, rhs) }
    public static var initialElement: T { T.max }
}

/// *Max* aggregate operation. Overlap friendly.
public enum SparseTableMaxAggregate<T: Comparable & MinBounded>: SparseTableMinMaxAggregate {
    public static func qualify(_ lhs: Element, _ rhs: Element) -> Bool { lhs > rhs }
    public static func aggregate(_ lhs: T, _ rhs: T) -> T { max(lhs, rhs) }
    public static var initialElement: T { T.min }
}
