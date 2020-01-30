import Foundation

public struct SparseTable<S: SparseTableQueryStrategy> {
    // MARK: - State

    public typealias Element = S.Aggregate.Element
    public typealias Result = S.Result

    let floorLog2: [Int]
    // sparse table
    var table: [[Element?]]
    let depth: Int

    let strategy: S

    // MARK: - Initialization

    public init(elements: [Element], strategy: S) {
        self.strategy = strategy
        self.floorLog2 = .precomputeFloorLog2(for: elements.count)
        self.depth = floorLog2[elements.count] + 1
        table = []
        guard !elements.isEmpty else { return }
        populateTable(elements)
        strategy.config(table: table, depth: depth, floorLog2: floorLog2)
    }

    // MARK: - UI

    public func rangeQuery<R>(in range: R) -> Result? where R: RangeExpression, R.Bound == Int {
        let range = range.relative(to: table)
        return strategy.rangeQuery(in: range)
    }

    // MARK: - Helpers

    // O(n * log n)
    private mutating func populateTable(_ elements: [Element]) {
        // Initialize table
        table = .init(
            repeating: .init(repeating: nil, count: depth),
            count: elements.count
        )
        // Fill first column
        elements.enumerated().forEach { i, e in
            table[i][0] = e
        }
        // Fill remaining column
        for level in 1..<depth {
            let len = 1 << level
            for i in 0..<(elements.count - len + 1) {
                let len2 = 1 << (level - 1)
                table[i][level] = S.Aggregate.aggregate(table[i][level - 1]!, table[i + len2][level - 1]!)
            }
        }
    }
}
