import Foundation

// MARK: - Query strategy

public protocol SparseTableQueryStrategy {
    associatedtype Aggregate: SparseTableAggregate
    associatedtype Result
    func config(table: [[Aggregate.Element?]], depth: Int, floorLog2: [Int])
    func rangeQuery(in range: Range<Int>) -> Result?
}
