import Foundation

public struct BinaryLiftingTable {
    // MARK: - State

    @usableFromInline
    var table: [[Int?]]
    public let treeLevels: Int
    public let maxJumps: Int
    @usableFromInline
    var lastIndexised: Int?

    // MARK: - Initialization

    public init(treeLevels: Int, nodes: Int? = nil) {
        precondition(treeLevels > 1)
        self.treeLevels = treeLevels
        self.maxJumps = BinaryLiftingTable.powerOf2JumpsForTreeLevels(treeLevels)!
        self.table = []
        if let nodes = nodes {
            self.table.reserveCapacity(nodes)
            ensureTableSize(for: nodes - 1)
        }
    }

    // MARK: - UI

    /// Indexise (preprocess) *index -> parentIndex* relation.
    ///
    /// - Complexity: O(log *n*) where *n* is the maximum number of tree levels.
    @inlinable
    public mutating func indexise(index: Int, parentIndex: Int) {
        precondition(index > lastIndexised ?? -1)
        defer { lastIndexised = index }
        ensureTableSize(for: index)
        table[index][0] = parentIndex
        for i in 1..<maxJumps {
            guard let v = table[table[index][i - 1]!][i - 1] else { break }
            table[index][i] = v
        }
    }

    /// Get `k`-th ancestor of `index` node.
    ///
    /// - Complexity: O(log *n*) where *n* is the maximum number of tree levels.
    @inlinable
    public func getAncestor(_ k: Int, of index: Int) -> Int? {
        precondition(index < table.count)
        guard k <= treeLevels - 1 else { return nil }
        var currentIndex = index
        for i in stride(from: maxJumps - 1, through: 0, by: -1) {
            let hopSteps = 1 << i
            if hopSteps & k != 0 {
                guard let nextIndex = table[currentIndex][i] else { return nil }
                currentIndex = nextIndex
            }
        }
        return currentIndex
    }

    // MARK: - Helpers

    // Ensure the size of the table is not less than index + 1. New entries are properly initialized.
    @usableFromInline
    mutating func ensureTableSize(for index: Int) {
        guard table.count < index + 1 else { return }
        (table.count..<(index + 1))
            .forEach { _ in
                table.append(makeNewJumpPointsRow())
            }
    }

    @inline(__always)
    func makeNewJumpPointsRow() -> [Int?] {
        .init(repeating: nil, count: maxJumps)
    }

    @inline(__always)
    private static func powerOf2JumpsForTreeLevels(_ levels: Int) -> Int? {
        guard let index = (levels - 1).MSBIndex else { return nil }
        return Int(index + 1)
    }
}
