import Foundation

extension Int: AdditiveInversive {
    @inlinable
    public static var neutralElement: Self { 0 }
    @inlinable
    public mutating func addOn(_ extra: Int) {
        self += extra
    }
    @inlinable
    public func addingOn(_ extra: Int) -> Self {
        return self + extra
    }
    @inlinable
    public mutating func exclude(_ part: Int) {
        self -= part
    }
    @inlinable
    public func excluding(_ part: Int) -> Self {
        return self - part
    }
}
