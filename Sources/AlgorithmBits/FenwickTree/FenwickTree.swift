import Foundation

// MARK: - FenwickTree

public struct FenwickTree<T: AdditiveInversive>: RangeQueryable {
    // MARK: - State

    @usableFromInline
    var tree: [T]

    // MARK: - Initialization

    public init(size: Int) {
        precondition(size >= 0)
        self.tree = .init(repeating: T.neutralElement, count: size)
    }

    public init(_ elements: [T]) {
        self.tree = FenwickTree.populate(with: elements)
    }

    // MARK: - UI

    /// Add on `extra` to element at index `idx`.
    ///
    /// - Complexity: O(log *n*) where *n* is the number of elements.
    @inlinable
    public mutating func addOn(_ extra: T, at idx: Int) {
        precondition(idx < tree.count)
        var idx = idx + 1 // algorithm works with 1-based indexes
        while idx <= tree.count {
            tree[idx - 1].addOn(extra)
            idx += idx.LSB2 // add last set bit
        }
    }

    /// Range query in the interval `range`.
    ///
    /// - Complexity: O(log *n*) where *n* is the number of elements.
    @inlinable
    public func rangeQuery<R>(in range: R) -> T where R: RangeExpression, R.Bound == Int {
        let r = range.relative(to: tree)
        precondition(r.upperBound <= tree.count)
        return prefixSum(r.upperBound - 1).excluding(r.lowerBound > 0
                                                     ? prefixSum(r.lowerBound - 1)
                                                     : T.neutralElement)
    }

    // MARK: - Helpers

    /// Compute the prefix sum for [0, idx].
    ///
    /// - Complexity: O(log *n*) where *n* is the number of elements.
    @usableFromInline @inline(__always)
    func prefixSum(_ idx: Int) -> T {
        var idx = idx + 1 // algorithm works with 1-based indexes
        var sum = T.neutralElement
        while idx > 0 {
            sum.addOn(tree[idx - 1])
            idx &= ~idx.LSB2
        }
        return sum
    }

    /// Construct a Fenwick tree with an initial set of elements.
    ///
    /// - Complexity: O(*n*) where *n* is the number of elements.
    static func populate(with elements: [T]) -> [T] {
        guard !elements.isEmpty else { return [] }
        var tree = elements // copy
        for idx in (1...elements.count) { // using 1-based index
            let parent = idx + idx.LSB2
            if parent <= elements.count {
                tree[parent - 1].addOn(tree[idx - 1])
            }
        }
        return tree
    }
}

// MARK: - Default Element type
extension FenwickTree where T == Int {
    public init(size: Int) {
        precondition(size >= 0)
        self.tree = .init(repeating: T.neutralElement, count: size)
    }
}

// MARK: - Collection

extension FenwickTree: MutableCollection {
    public typealias Element = T
    @inlinable
    public func index(after idx: Int) -> Int { tree.index(after: idx) }
    @inlinable
    public var startIndex: Int { tree.startIndex }
    @inlinable
    public var endIndex: Int { tree.endIndex }
    /// Point access/update the element at position `idx`.
    ///
    /// - Complexity: O(log *n*) where *n* is the number of elements.
    @inlinable
    public subscript(idx: Int) -> T {
        get {
            precondition(idx < tree.count, "\(idx) \(tree.count)")
            // Improvement: https://www.topcoder.com/thrive/articles/Binary%20Indexed%20Trees#reada
            var idx = idx + 1 // algorithm works with 1-based indexes
            var sum = tree[idx - 1]
            if idx > 0 { // the special case
                let z = idx - idx.LSB2
                idx -= 1
                while idx != z {
                    sum.exclude(tree[idx - 1])
                    idx -= idx.LSB2
                }
            }
            return sum
        }
        set {
            precondition(idx < tree.count)
            addOn(newValue.excluding(self[idx]), at: idx)
        }
    }
}

// MARK: - ExpressibleByArrayLiteral

extension FenwickTree: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: T...) {
        self.init(elements)
    }
}

// MARK: - CustomStringConvertible, CustomDebugStringConvertible

extension FenwickTree: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return Array(self[0..<tree.count]).description
    }
    public var debugDescription: String {
        return Array(self[0..<tree.count]).description
    }
}
