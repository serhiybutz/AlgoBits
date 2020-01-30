import Foundation

extension Array where Element == Int {
    // Precompute quick lookup table for floor(log2(i)), i <= i <= maxN.
    public static func precomputeFloorLog2(for maxN: Int) -> [Int] {
        var log2: [Int] = .init(repeating: 0, count: maxN + 1)
        if maxN >= 2 {
            for i in (2...maxN) {
                log2[i] = log2[i >> 1] + 1
            }
        }
        return log2
    }
}
