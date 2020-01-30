import Foundation

// https://stackoverflow.com/questions/28525484/how-to-find-max-value-for-double-and-float-in-swift
public protocol MinBounded {
    static var min: Self { get }
}
extension Int: MinBounded {}
extension UInt: MinBounded {}
extension Int8: MinBounded {}
extension Int16: MinBounded {}
extension Int32: MinBounded {}
extension Int64: MinBounded {}
extension UInt8: MinBounded {}
extension UInt16: MinBounded {}
extension UInt32: MinBounded {}
extension UInt64: MinBounded {}
extension Float: MinBounded {
    public static var min: Float { -Float.greatestFiniteMagnitude }
}
extension Double: MinBounded {
    public static var min: Double { -Double.greatestFiniteMagnitude }
}



public protocol MaxBounded {
    static var max: Self { get }
}
extension Int: MaxBounded {}
extension UInt: MaxBounded {}
extension Int8: MaxBounded {}
extension Int16: MaxBounded {}
extension Int32: MaxBounded {}
extension Int64: MaxBounded {}
extension UInt8: MaxBounded {}
extension UInt16: MaxBounded {}
extension UInt32: MaxBounded {}
extension UInt64: MaxBounded {}
extension Float: MaxBounded {
    public static var max: Float { Float.greatestFiniteMagnitude }
}
extension Double: MaxBounded {
    public static var max: Double { Double.greatestFiniteMagnitude }
}
