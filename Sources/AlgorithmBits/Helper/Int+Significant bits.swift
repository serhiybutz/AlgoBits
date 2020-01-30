import Foundation

extension Int32 {
    /// Returns the index of the least significant bit.
    ///
    /// Bits are numbered starting at 0, the least significant bit's index.
    /// A return value of *nil* means that the value of `self` was less than or equal to 0.
    @inlinable
    public var LSBIndex: Int32? {
        guard self > 0 else { return nil }
        return ffs(self) - 1
    }
    /// Returns the value of the least significant bit.
    @inlinable
    public var LSB: Int32? {
        guard let index = LSBIndex else { return nil }
        return 1 << index
    }
    /// Returns the index of the most significant bit.
    ///
    /// Bits are numbered starting at 0, the least significant bit's index.
    /// A return value of *nil* means that the value of `self` was less than or equal to 0.
    @inlinable
    public var MSBIndex: Int32? {
        guard self > 0 else { return nil }
        return fls(self) - 1
    }
    /// Returns the value of the most significant bit.
    @inlinable
    public var MSB: Int32? {
        guard let index = MSBIndex else { return nil }
        return 1 << index
    }
}

extension Int {
    /// Returns the index of the least significant bit.
    ///
    /// Bits are numbered starting at 0, the least significant bit's index.
    /// A return value of *nil* means that the value of `self` was less than or equal to 0.
    @inlinable
    public var LSBIndex: Int32? {
        guard self > 0 else { return nil }
        return ffsl(self) - 1
    }
    /// Returns the value of the least significant bit.
    @inlinable
    public var LSB: Int? {
        guard let index = LSBIndex else { return nil }
        return 1 << index
    }
    /// Returns the index of the most significant bit.
    ///
    /// Bits are numbered starting at 0, the least significant bit's index.
    /// A return value of *nil* means that the value of `self` was less than or equal to 0.
    @inlinable
    public var MSBIndex: Int32? {
        guard self > 0 else { return nil }
        return flsl(self) - 1
    }
    /// Returns the value of the most significant bit.
    @inlinable
    public var MSB: Int? {
        guard let index = MSBIndex else { return nil }
        return 1 << index
    }
}

extension Int64 {
    /// Returns the index of the least significant bit.
    ///
    /// Bits are numbered starting at 0, the least significant bit's index.
    /// A return value of *nil* means that the value of `self` was less than or equal to 0.
    @inlinable
    public var LSBIndex: Int32? {
        guard self > 0 else { return nil }
        return ffsll(self) - 1
    }
    /// Returns the value of the least significant bit.
    @inlinable
    public var LSB: Int64? {
        guard let index = LSBIndex else { return nil }
        return 1 << index
    }
    /// Returns the index of the most significant bit.
    ///
    /// Bits are numbered starting at 0, the least significant bit's index.
    /// A return value of *nil* means that the value of `self` was less than or equal to 0.
    @inlinable
    public var MSBIndex: Int32? {
        guard self > 0 else { return nil }
        return flsll(self) - 1
    }
    /// Returns the value of the most significant bit.
    @inlinable
    public var MSB: Int64? {
        guard let index = MSBIndex else { return nil }
        return 1 << index
    }
}

extension SignedInteger {
    /// Returns the value of the least significant bit (LSB).
    ///
    /// lsb(108) = lsb(0b1101100) =     0b100 = 4
    /// lsb(104) = lsb(0b1101000) =    0b1000 = 8
    /// lsb(96)  = lsb(0b1100000) =  0b100000 = 32
    /// lsb(64)  = lsb(0b1000000) = 0b1000000 = 64
    @inlinable
    public var LSB2: Self {
        self & -self // isolates the lowest one bit value
    }
}

extension BinaryInteger {
    /// Returns the index of the most significant bit.
    // https://stackoverflow.com/questions/671815/what-is-the-fastest-most-efficient-way-to-find-the-highest-set-bit-msb-in-an-i#answer-4970859
    public var MSBIndex2: Int? {
        guard self > 0 else { return nil }
        var v = self
        var position = 0
        v >>= 1
        while v > 0 {
            position += 1
            v >>= 1
        }
        return position
    }
}
