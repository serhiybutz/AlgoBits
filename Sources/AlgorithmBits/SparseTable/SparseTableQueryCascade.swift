import Foundation

public final class SparseTableQueryCascade<A: SparseTableAggregate>: SparseTableQueryStrategy {
    public typealias Aggregate = A
    public typealias Result = A.Element

    // sparse table
    var table: [[A.Element?]]!
    var depth: Int!
    var floorLog2: [Int]!

    public func config(table: [[A.Element?]], depth: Int, floorLog2: [Int]) {
        self.table = table
        self.depth = depth
        self.floorLog2 = floorLog2
    }

    // Query the smallest element in the range [l, r] by doing a cascading min query, O(log n).
    public func rangeQuery(in range: Range<Int>) -> Result? {
        let upper = range.upperBound - 1 // (`range` doesN't include an upper bound)
        var lower = range.lowerBound

        var result = A.initialElement
        var level = floorLog2[upper - lower + 1]
        while lower <= upper {
            result = A.aggregate(result, table[lower][level]!)
            lower += 1 << level
            level = floorLog2[upper - lower + 1]
        }
        return result
    }
}
