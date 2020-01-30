import XCTest
@testable
import AlgorithmBits

final class SparseTableTests: XCTestCase {
    func test_minOverlapFriendly() {
        // Given
        let elements = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].shuffled()
        let sut = SparseTable(elements: elements, strategy: SparseTableQueryMinMax<SparseTableMinAggregate>())
        for i in 0..<elements.count {
            for j in i..<elements.count {
                var min = Int.max
                var minIndex: Int? = nil
                (i...j).forEach {
                    if min > elements[$0] {
                        min = elements[$0]
                        minIndex = $0
                    }
                }
                // Then
                XCTAssertEqual(sut.rangeQuery(in: i...j)?.element, min)
                XCTAssertEqual(sut.rangeQuery(in: i...j)?.index, minIndex)
            }
        }
    }

    func test_maxOverlapFriendly() {
        // Given
        let elements = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].shuffled()
        let sut = SparseTable(elements: elements, strategy: SparseTableQueryMinMax<SparseTableMaxAggregate>())
        for i in 0..<elements.count {
            for j in i..<elements.count {
                var max = Int.min
                var maxIndex: Int? = nil
                (i...j).forEach {
                    if max < elements[$0] {
                        max = elements[$0]
                        maxIndex = $0
                    }
                }
                // Then
                XCTAssertEqual(sut.rangeQuery(in: i...j)?.element, max)
                XCTAssertEqual(sut.rangeQuery(in: i...j)?.index, maxIndex)
            }
        }
    }

    func test_minCascadingly() {
        // Given
        let elements = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].shuffled()
        let sut = SparseTable(elements: elements, strategy: SparseTableQueryCascade<SparseTableMinAggregate>())
        for i in 0..<elements.count {
            for j in i..<elements.count {
                let expected = elements[i...j].reduce(Int.max, min)
                // Then
                XCTAssertEqual(sut.rangeQuery(in: i...j), expected)
            }
        }
    }

    func test_sum() {
        // Given
        let elements = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].shuffled()
        let sut = SparseTable(elements: elements, strategy: SparseTableQueryCascade<SparseTableSumAggregate>())
        for i in 0..<elements.count {
            for j in i..<elements.count {
                let expected = elements[i...j].reduce(Int.zero, +)
                // Then
                XCTAssertEqual(sut.rangeQuery(in: i...j), expected)
            }
        }
    }
}
