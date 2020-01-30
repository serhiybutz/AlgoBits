import Foundation

// https://www.topcoder.com/thrive/articles/Binary%20Indexed%20Trees#find
extension FenwickTree where T == Int {
    /// Finds an index with the given cumulative element.
    public func findAnyIndex(of cumElement: Int) -> Int? {
        var cumElement = cumElement
        let maxIdx = tree.count
        var bitMask = maxIdx.MSB!
        var idx = 0
        while bitMask != 0 {
            let tIdx = idx + bitMask
            bitMask >>= 1
            if tIdx > maxIdx { continue }
            if cumElement == tree[tIdx - 1] {
                return tIdx - 1
            } else if cumElement > tree[tIdx - 1] {
                idx = tIdx
                cumElement -= tree[tIdx - 1]
            }
        }
        if cumElement != 0 {
            return nil
        } else {
            return idx - 1
        }
    }

    /// Finds an index with the given cumulative element.
    public func findGreatestIndex(of cumElement: Int) -> Int? {
        var cumElement = cumElement
        let maxIdx = tree.count
        var bitMask = maxIdx.MSB!
        var idx = 0
        while bitMask != 0 {
            let tIdx = idx + bitMask
            bitMask >>= 1
            if tIdx > maxIdx { continue }
            if cumElement >= tree[tIdx - 1] {
                idx = tIdx
                cumElement -= tree[tIdx - 1]
            }
        }
        if cumElement != 0 {
            return nil
        } else {
            return idx - 1
        }
    }
}
