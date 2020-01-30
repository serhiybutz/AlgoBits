import Foundation

/// Segment Tree (recursive version)

public final class RecursiveSegmentTree<T: AdditiveInversive>: RangeQueryable {
    // MARK: - State

    @usableFromInline
    let size: Int
    @usableFromInline
    var tree: [T]

    // MARK: - Initialization

    public init(size: Int) {
        precondition(size >= 0)
        self.size = size

        // Alternatively:
        let bitsCoveringAllElements = (size - 1).MSBIndex.map { $0 + 1 } ?? 0
        let maxSize = (1 << (bitsCoveringAllElements + 1)) - 1
        tree = .init(repeating: T.neutralElement, count: maxSize)
    }

    public convenience init(_ elements: [T]) {
        self.init(size: elements.count)
        guard !elements.isEmpty else { return }
        populateTree(originalElements: elements, currentIndex: 0, coveredRange: ClosedRange(elements.indices))
    }

    // MARK: - UI

    /// Add on `extra` to element at index `idx`.
    ///
    /// - Complexity: O(log *n*) where *n* is the number of elements.
    @inlinable
    public func addOn(_ extra: T, at idx: Int) {
        precondition(idx < size)
        _ = traverseTree(
            currentIndex: 0,
            coveredRange: 0...(size - 1),
            edgeCaseHandler: { (currentRange: ClosedRange<Int>, currentIndex: Int) -> EdgeCaseHandlerResult<Int> in
                guard currentRange ~= idx else { return .cutShort(nil) }
                tree[currentIndex].addOn(extra)
                if currentRange.count == 1 {
                    return .cutShort(nil)
                }
                return .drillDown
            })
    }

    /// Range query in the interval `range`.
    ///
    /// - Complexity: O(log *n*) where *n* is the number of elements.
    public func rangeQuery<R>(in range: R) -> T where R: RangeExpression, R.Bound == Int {
        let range = ClosedRange(range.relative(to: tree)) // `tree` is bigger than the original element array, so using it will do the trick
        precondition(range.upperBound <= size)

        return traverseTree(
            currentIndex: 0,
            coveredRange: 0...(size - 1),
            edgeCaseHandler: { (currentRange: ClosedRange<Int>, currentIndex: Int) -> EdgeCaseHandlerResult<T> in
                if currentRange.lowerBound >= range.lowerBound && currentRange.upperBound <= range.upperBound {
                    return .cutShort(tree[currentIndex])
                } else if currentRange.overlaps(range) {
                    return .drillDown
                } else {
                    return .cutShort(nil)
                }
            },
            recurHandler: { (lhs: T?, rhs: T?, index: Int) -> T in
                return (lhs ?? T.neutralElement).addingOn(rhs ?? T.neutralElement)
            })!
    }

    // MARK: - Helpers

    /// Populate the segment tree from an initial set of elements.
    ///
    /// - Complexity: O(*n*) where *n* is the number of elements.
    private func populateTree(
        originalElements: [T],
        currentIndex: Int,
        coveredRange: ClosedRange<Int>)
    {
        _ = traverseTree(
            currentIndex: 0, // aggregate index
            coveredRange: coveredRange, // aggregate range
            edgeCaseHandler: { (range: ClosedRange<Int>, index: Int) -> EdgeCaseHandlerResult<T> in
                if range.count == 1 {
                    let element = originalElements[range.lowerBound]
                    tree[index] = element
                    return .cutShort(element)
                } else {
                    return .drillDown
                }
            },
            recurHandler: { (lhs: T?, rhs: T?, index: Int) -> T in
                let elementSum = lhs!.addingOn(rhs!)
                self.tree[index] = elementSum
                return elementSum
            })
    }

    @usableFromInline
    enum EdgeCaseHandlerResult<R> {
        case drillDown
        case cutShort(R?)
    }

    @usableFromInline
    func traverseTree<R>(
        currentIndex: Int, // aggregate index
        coveredRange: ClosedRange<Int>, // aggregate range
        edgeCaseHandler: (_ range: ClosedRange<Int>, _ index: Int) -> EdgeCaseHandlerResult<R>,
        recurHandler: ((_ lhs: R?, _ rhs: R?, _ index: Int) -> R?)? = nil) -> R?
    {
        // edge case
        switch edgeCaseHandler(coveredRange, currentIndex) {
        case .cutShort(let result):
            return result
        case .drillDown: break
        }
        let mid = (coveredRange.upperBound + coveredRange.lowerBound) >> 1
        let v1 = traverseTree(currentIndex: 2 * currentIndex + 1,
                              coveredRange: coveredRange.lowerBound...mid,
                              edgeCaseHandler: edgeCaseHandler,
                              recurHandler: recurHandler)
        let v2 = traverseTree(currentIndex: 2 * currentIndex + 2,
                              coveredRange: (mid + 1)...coveredRange.upperBound,
                              edgeCaseHandler: edgeCaseHandler,
                              recurHandler: recurHandler)
        return recurHandler?(v1, v2, currentIndex)
    }
}

// MARK: - Collection

extension RecursiveSegmentTree: MutableCollection {
    public typealias Element = T
    @inlinable
    public func index(after idx: Int) -> Int { idx + 1 }
    @inlinable
    public var startIndex: Int { 0 }
    @inlinable
    public var endIndex: Int { size }
    /// Point access/update the element at position `idx`.
    ///
    /// - Complexity: get - O(log *n*), set - O(log *n*) where *n* is the number of elements.
    @inlinable
    public subscript(idx: Int) -> T {
        get {
            precondition(idx < size)
            return traverseTree(
                currentIndex: 0,
                coveredRange: 0...(size - 1),
                edgeCaseHandler: { (currentRange: ClosedRange<Int>, currentIndex: Int) -> EdgeCaseHandlerResult<T> in
                    guard currentRange ~= idx else { return .cutShort(nil) }
                    if currentRange.count == 1 {
                        return .cutShort(tree[currentIndex])
                    }
                    return .drillDown
                },
                recurHandler: { (lhs: T?, rhs: T?, index: Int) -> T in
                    return lhs ?? rhs!
                })!
        }
        set {
            precondition(idx < size)
            let extra = newValue.excluding(self[idx])
            addOn(extra, at: idx)
        }
    }
}

// MARK: - ExpressibleByArrayLiteral

extension RecursiveSegmentTree: ExpressibleByArrayLiteral {
    public convenience init(arrayLiteral elements: T...) {
        self.init(elements)
    }
}

// MARK: - CustomStringConvertible, CustomDebugStringConvertible

extension RecursiveSegmentTree: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        tree.description
    }
    public var debugDescription: String {
        tree.description
    }
}
