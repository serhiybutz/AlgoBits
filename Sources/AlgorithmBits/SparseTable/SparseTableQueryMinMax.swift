import Foundation

public final class SparseTableQueryMinMax<A: SparseTableMinMaxAggregate>: SparseTableQueryStrategy {
    public typealias Aggregate = A
    public typealias Result = (element: A.Element, index: Int)

    // sparse table
    var table: [[A.Element?]]!
    var depth: Int!
    var floorLog2: [Int]!

    var indexTable: [[Int?]]!

    public func config(table: [[A.Element?]], depth: Int, floorLog2: [Int]) {
        self.table = table
        self.depth = depth
        self.floorLog2 = floorLog2
        populateIndexTable()
    }

    // O(n * log n)
    func populateIndexTable() {
        indexTable = .init(
            repeating: .init(repeating: nil, count: depth),
            count: table.count
        )
        // Fill the first level (column=0)
        table.enumerated().forEach { i, _ in
            indexTable[i][0] = i
        }
        // Fill the remaining levels
        for level in 1..<depth {
            let len = 1 << level
            for i in 0..<(table.count - len + 1) {
                let len2 = 1 << (level - 1)
                let lhs = table[i][level - 1]!
                let rhs = table[i + len2][level - 1]!
                // Save/propagate the index of smallest element
                indexTable[i][level] = A.qualify(lhs, rhs) || lhs == rhs
                ? indexTable[i][level - 1]
                : indexTable[i + len2][level - 1]
            }
        }
    }

    // Query the smallest element in the range [l, r], O(1).
    public func rangeQuery(in range: Range<Int>) -> Result? {
        let upper = range.upperBound - 1 // (`range` doesN't include an upper bound)
        let lower = range.lowerBound

        let wholeLen = upper - lower + 1
        let level = floorLog2[wholeLen]

        let len = 1 << level
        let lhs = table[lower][level]!
        let rhs = table[upper - len + 1][level]!

        let element = A.aggregate(lhs, rhs)

        // Also get the index of the minimum element in the range [l, r] in the input values array. If there are multiple smallest elements, the first index is returned
        let index = A.qualify(lhs, rhs) || lhs == rhs
        ? indexTable[lower][level]!
        : indexTable[upper - len + 1][level]!

        return (element: element, index: index)
    }
}
