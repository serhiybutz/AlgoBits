import Foundation

extension Range where Bound == Int {
    var asClosedRange: ClosedRange<Bound> {
        ClosedRange(self)
    }
}
