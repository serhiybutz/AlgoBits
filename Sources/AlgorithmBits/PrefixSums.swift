import Foundation

// MARK: - PrefixSums

public struct PrefixSums<T: AdditiveInversive>: RangeQueryable {
    // MARK: - State

    @usableFromInline
    var prefixSums: [T]

    // MARK: - Initialization

    public init(size: Int) {
        precondition(size >= 0)
        self.prefixSums = .init(repeating: T.neutralElement, count: size)
    }

    public init(_ elements: [T]) {
        self.prefixSums = elements
        precomputePrefixSumsInPlace(&prefixSums)
    }

    // MARK: - UI

    /// Add on `extra` to element at index `idx`.
    ///
    /// - Complexity: O(*n*) where *n* is the number of elements.
    @inlinable
    public mutating func addOn(_ extra: T, at idx: Int) {
        precondition(idx < prefixSums.count)
        // Revert the region of dependents back to the original elements
        prefixSums[idx] = extra
        // Precompute the sums for the region of dependents including the newly updated element
        precomputePrefixSumsInPlace(&prefixSums, startingAt: idx)
    }

    /// Range query in the interval `range`.
    ///
    /// - Complexity: O(1).
    @inlinable
    public func rangeQuery<R>(in range: R) -> T where R: RangeExpression, R.Bound == Int {
        let r = range.relative(to: prefixSums)
        precondition(r.upperBound <= prefixSums.count)
        return prefixSums[r.upperBound - 1].excluding((r.lowerBound > 0
                                                       ? prefixSums[r.lowerBound - 1]
                                                       : T.neutralElement))
    }

    // MARK: - Helpers

    /// Precompute prefix sums starting at `startIndex` in place.
    ///
    /// - Complexity: O(*n*) where *n* is the number of elements.
    @usableFromInline @inline(__always)
    func precomputePrefixSumsInPlace(_ prefixSums: inout [T], startingAt startIndex: Int = 1) {
        guard prefixSums.count > 0 else { return }
        for i in Swift.max(1, startIndex)..<prefixSums.count {
            prefixSums[i].addOn(prefixSums[i - 1])
        }
    }
}

// MARK: - Default Element type
extension PrefixSums where T == Int {
    public init(size: Int) {
        precondition(size >= 0)
        self.prefixSums = .init(repeating: T.neutralElement, count: size)
    }
}

// MARK: - Collection

extension PrefixSums: MutableCollection {
    @inlinable
    public func index(after idx: Int) -> Int { prefixSums.index(after: idx) }
    @inlinable
    public var startIndex: Int { prefixSums.startIndex }
    @inlinable
    public var endIndex: Int { prefixSums.endIndex }
    /// Point access/update the element at position `idx`.
    ///
    /// - Complexity: get - O(1), set - O(*n*) where *n* is the number of elements.
    @inlinable
    public subscript(idx: Int) -> T {
        get {
            precondition(idx < prefixSums.count)
            return idx > 0
                ? rangeQuery(in: idx...idx)
                : prefixSums[0]
        }
        set {
            precondition(idx < prefixSums.count)
            ((idx + 1)..<prefixSums.count).reversed().forEach { j in prefixSums[j] = self[j] }
            addOn(newValue, at: idx)
        }
    }
}

// MARK: - ExpressibleByArrayLiteral

extension PrefixSums: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: T...) {
        self.init(elements)
    }
}

// MARK: - CustomStringConvertible, CustomDebugStringConvertible

extension PrefixSums: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return Array(self[0..<prefixSums.count]).description
    }
    public var debugDescription: String {
        return Array(self[0..<prefixSums.count]).description
    }
}
