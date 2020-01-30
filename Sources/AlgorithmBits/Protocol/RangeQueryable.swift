import Foundation

public protocol RangeQueryable {
    associatedtype Element: AdditiveInversive
    mutating func addOn(_ extra: Element, at idx: Int)
    func rangeQuery<R>(in range: R) -> Element where R: RangeExpression, R.Bound == Int
    init(size: Int)
    init(_ elements: [Element])
    init(arrayLiteral elements: Element...)
}
