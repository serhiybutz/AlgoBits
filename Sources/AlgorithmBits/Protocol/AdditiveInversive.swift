import Foundation

public protocol AdditiveInversive {
    static var neutralElement: Self { get }
    func addingOn(_ extra: Self) -> Self
    mutating func addOn(_ extra: Self)
    func excluding(_ part: Self) -> Self
    mutating func exclude(_ part: Self)
}
