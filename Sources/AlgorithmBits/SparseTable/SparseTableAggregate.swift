import Foundation

/// Abstract aggregate operation.
public protocol SparseTableAggregate {
    associatedtype Element
    static func aggregate(_ lhs: Element, _ rhs: Element) -> Element
    static var initialElement: Element { get }
}

