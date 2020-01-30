import Foundation

/// Segment Tree (iterative version)

public final class IterativeSegmentTree<T: AdditiveInversive>: RangeQueryable {
    // MARK: - State

    @usableFromInline
    let size: Int // actual size
    @usableFromInline
    let maxSize: Int // closest covering power of 2
    @usableFromInline
    var tree: [T] // internally, a 1-based indexed array

    // MARK: - Initialization

    public init(size: Int) {
        precondition(size >= 0)
        self.size = size
        maxSize = size.MSBIndex.map { 1 << ($0 + 1) } ?? 0
        tree = .init(repeating: T.neutralElement, count: 2 * maxSize)
    }

    public convenience init(_ elements: [T]) {
        self.init(size: elements.count)
        guard !elements.isEmpty else { return }
        tree[maxSize..<(maxSize + size)] = elements[0..<size]
        populateAggregates()
    }

    // MARK: - UI

    /// Add on `extra` to element at index `idx`.
    ///
    /// - Complexity: O(log *n*) where *n* is the number of elements.
    @inlinable
    public func addOn(_ extra: T, at idx: Int) {
        precondition(idx < size)
        var idx = idx + maxSize // (note moving to 1-based indexing)
        while idx > 0 {
            tree[idx].addOn(extra)
            idx >>= 1
        }
    }


    /// Range query in the interval `range`.
    ///
    /// - Complexity: O(log *n*) where *n* is the number of elements.
    public func rangeQuery<R>(in range: R) -> T where R: RangeExpression, R.Bound == Int {
        let range = range.relative(to: tree) // `tree` is bigger than the original element array, so using it will do the trick
        precondition(range.upperBound <= size)
        var result = T.neutralElement
        var lower = range.lowerBound + maxSize
        var upper = range.upperBound + maxSize
        while lower < upper {
            if lower & 1 != 0 {
                result.addOn(tree[lower])
                lower += 1
            }
            if upper & 1 != 0 {
                upper -= 1
                result.addOn(tree[upper])
            }
            lower >>= 1
            upper >>= 1
        }
        return result
    }

    // MARK: - Helpers

    /// Populate the segment tree from the initial set of elements.
    ///
    /// - Complexity: O(*n*) where *n* is the number of elements.
    private func populateAggregates() {
        for i in stride(from: maxSize - 1, to: 0, by: -1) {
            tree[i] = tree[i << 1].addingOn(tree[(i << 1) | 1])
        }
    }
}

// MARK: - Collection

extension IterativeSegmentTree: MutableCollection {
    public typealias Element = T
    @inlinable
    public func index(after idx: Int) -> Int { idx + 1 }
    @inlinable
    public var startIndex: Int { 0 }
    @inlinable
    public var endIndex: Int { size }
    /// Point access/update the element at position `idx`.
    ///
    /// - Complexity: get - O(1), set - O(log *n*) where *n* is the number of elements.
    @inlinable
    public subscript(idx: Int) -> T {
        get {
            precondition(idx < size)
            return tree[maxSize + idx] // (note moving to 1-based indexing)
        }
        set {
            precondition(idx < size)
            let extra = newValue.excluding(self[idx])
            addOn(extra, at: idx)
        }
    }
}

// MARK: - ExpressibleByArrayLiteral

extension IterativeSegmentTree: ExpressibleByArrayLiteral {
    public convenience init(arrayLiteral elements: T...) {
        self.init(elements)
    }
}

// MARK: - CustomStringConvertible, CustomDebugStringConvertible

extension IterativeSegmentTree: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return Array(self.tree[maxSize..<(maxSize + size)]).description
    }
    public var debugDescription: String {
        return Array(self.tree[maxSize..<(maxSize + size)]).description
    }
}
