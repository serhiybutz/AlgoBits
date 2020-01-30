import Foundation

// https://forums.swift.org/t/even-and-odd-integers/11774/93

extension BinaryInteger {
    @inlinable @inline(__always)
    /// A Boolean value indicating whether this value is even.
    ///
    /// An integer is even if it is evenly divisible by two.
    public var isEven: Bool {
        return self & 1 == 0
    }

    @inlinable @inline(__always)
    /// A Boolean value indicating whether this value is odd.
    ///
    /// An integer is odd if it is not evenly divisible by two.
    public var isOdd: Bool {
        return self & 1 == 1
    }
}
