import XCTest
import AlgorithmBits

final class PrefixSummableTreeTests: XCTestCase {
    typealias PrefexSummableTreeType<T: RangeQueryable & MutableCollection & ExpressibleByArrayLiteral> = T.Type where T.Element == Int, T.Index == Int, T.ArrayLiteralElement == Int

    let array = [1, 4, 2, 1, 3, 5, 0, 2, 3]

    func test_PrefixSums() {
        let SUT = PrefixSums<Int>.self
        _test_initializesFromArray(SUT)
        _test_initializesFromArrayLiteral(SUT)
        _test_initializesBySize(SUT)
        _test_zeroElements(SUT)
        _test_oneElement(SUT)
        _test_twoElements(SUT)
        _test_threeElements(SUT)
        _test_fourElements(SUT)
        _test_fiveElements(SUT)
    }

    func test_FenwickTree() {
        let SUT = FenwickTree<Int>.self
        _test_initializesFromArray(SUT)
        _test_initializesFromArrayLiteral(SUT)
        _test_initializesBySize(SUT)
        _test_zeroElements(SUT)
        _test_oneElement(SUT)
        _test_twoElements(SUT)
        _test_threeElements(SUT)
        _test_fourElements(SUT)
        _test_fiveElements(SUT)
    }

    func test_FenwickTree_find() {
        // Given
        let sut = FenwickTree(array)
        // Then
        XCTAssertEqual(sut.findAnyIndex(of: 1)!, 0)
        XCTAssertEqual(sut.findAnyIndex(of: 5)!, 1)
        XCTAssertEqual(sut.findAnyIndex(of: 7)!, 2)
        XCTAssertEqual(sut.findAnyIndex(of: 8)!, 3)
        XCTAssertEqual(sut.findAnyIndex(of: 11)!, 4)
//        XCTAssertEqual(sut.findAnyIndex(of: 16)!, 5)
        XCTAssertEqual(sut.findAnyIndex(of: 18)!, 7)
        XCTAssertEqual(sut.findAnyIndex(of: 21)!, 8)
        XCTAssertNil(sut.findAnyIndex(of: 100))
        // Then
        XCTAssertEqual(sut.findGreatestIndex(of: 1)!, 0)
        XCTAssertEqual(sut.findGreatestIndex(of: 5)!, 1)
        XCTAssertEqual(sut.findGreatestIndex(of: 7)!, 2)
        XCTAssertEqual(sut.findGreatestIndex(of: 8)!, 3)
        XCTAssertEqual(sut.findGreatestIndex(of: 11)!, 4)
        XCTAssertEqual(sut.findGreatestIndex(of: 16)!, 6)
        XCTAssertEqual(sut.findGreatestIndex(of: 18)!, 7)
        XCTAssertEqual(sut.findGreatestIndex(of: 21)!, 8)
        XCTAssertNil(sut.findGreatestIndex(of: 100))
    }

    // MARK: - Shared

    func _test_initializesFromArray<T>(_ SUT: PrefexSummableTreeType<T>, line: UInt = #line)  {
        // Given
        let sut = SUT.init(array)
        // Then
        XCTAssertEqual(sut.count, array.count, line: line)
    }
    func _test_initializesFromArrayLiteral<T>(_ SUT: PrefexSummableTreeType<T>, line: UInt = #line) {
        // Given
        let sut: T = [1, 3, 4]
        // Then
        XCTAssertEqual(sut.count, 3, line: line)
    }
    func _test_initializesBySize<T>(_ SUT: PrefexSummableTreeType<T>, line: UInt = #line) {
        // Given
        let sut = SUT.init(size: 10)
        // Then
        XCTAssertEqual(sut.count, 10, line: line)
    }
    func _test_zeroElements<T>(_ SUT: PrefexSummableTreeType<T>, line: UInt = #line) {
        // Given
        let sut: T = []
        // Then
        XCTAssertEqual(sut.count, 0, line: line)
    }
    func _test_oneElement<T>(_ SUT: PrefexSummableTreeType<T>, line: UInt = #line) {
        // Given
        var sut: T = [123]
        // Then
        XCTAssertEqual(sut.count, 1, line: line)
        XCTAssertEqual(sut[0], 123, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...0), 123, line: line)
        // When
        sut[0] = 333
        // Then
        XCTAssertEqual(sut[0], 333, line: line)
    }
    func _test_twoElements<T>(_ SUT: PrefexSummableTreeType<T>, line: UInt = #line) {
        // Given
        var sut: T = [5, 10]
        // Then
        XCTAssertEqual(sut.count, 2, line: line)
        XCTAssertEqual(sut[0], 5, line: line)
        XCTAssertEqual(sut[1], 10, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...0), 5, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 1...1), 10, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...1), 15, line: line)

        // When
        sut[0] = 7
        // Then
        XCTAssertEqual(sut[0], 7, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...0), 7, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 1...1), 10, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...1), 17, line: line)

        // When
        sut[1] = 12
        // Then
        XCTAssertEqual(sut[1], 12, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...0), 7, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 1...1), 12, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...1), 19, line: line)
    }
    func _test_threeElements<T>(_ SUT: PrefexSummableTreeType<T>, line: UInt = #line) {
        // Given
        var sut: T = [5, 10, 20]
        // Then
        XCTAssertEqual(sut.count, 3, line: line)
        XCTAssertEqual(sut[0], 5, line: line)
        XCTAssertEqual(sut[1], 10, line: line)
        XCTAssertEqual(sut[2], 20, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...0), 5, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 1...1), 10, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 2...2), 20, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...1), 15, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...2), 35, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 1...2), 30, line: line)
        // When
        sut[0] = 7
        // Then
        XCTAssertEqual(sut[0], 7, line: line)
        XCTAssertEqual(sut[1], 10, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...2), 37, line: line)
    }
    func _test_fourElements<T>(_ SUT: PrefexSummableTreeType<T>, line: UInt = #line) {
        // Given
        var sut: T = [5, 10, 20, 40]
        // Then
        XCTAssertEqual(sut.count, 4, line: line)
        XCTAssertEqual(sut[0], 5, line: line)
        XCTAssertEqual(sut[1], 10, line: line)
        XCTAssertEqual(sut[2], 20, line: line)
        XCTAssertEqual(sut[3], 40, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...0), 5, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 1...1), 10, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 2...2), 20, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 3...3), 40, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...1), 15, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...2), 35, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...3), 75, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 1...2), 30, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 1...3), 70, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 2...3), 60, line: line)
        // When
        sut[0] = 7
        // Then
        XCTAssertEqual(sut[0], 7, line: line)
        XCTAssertEqual(sut[1], 10, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...3), 77, line: line)
    }
    func _test_fiveElements<T>(_ SUT: PrefexSummableTreeType<T>, line: UInt = #line) {
        // Given
        var sut: T = [5, 10, 20, 40, 80]
        // Then
        XCTAssertEqual(sut.count, 5, line: line)
        XCTAssertEqual(sut[0], 5, line: line)
        XCTAssertEqual(sut[1], 10, line: line)
        XCTAssertEqual(sut[2], 20, line: line)
        XCTAssertEqual(sut[3], 40, line: line)
        XCTAssertEqual(sut[4], 80, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...0), 5, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 1...1), 10, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 2...2), 20, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 3...3), 40, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 4...4), 80, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...1), 15, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...2), 35, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...3), 75, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...4), 155, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 1...2), 30, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 1...3), 70, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 1...4), 150, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 2...3), 60, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 2...4), 140, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 3...4), 120, line: line)
        // When
        sut[0] = 7
        // Then
        XCTAssertEqual(sut[0], 7, line: line)
        XCTAssertEqual(sut[1], 10, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...4), 157, line: line)
    }
}
