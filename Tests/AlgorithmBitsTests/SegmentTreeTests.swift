import XCTest
@testable
import AlgorithmBits

final class SegmentTreeTests: XCTestCase {
    typealias SegmentTreeType<T: RangeQueryable & MutableCollection & ExpressibleByArrayLiteral> = T.Type where T.Element == Int, T.Index == Int, T.ArrayLiteralElement == Int

    // MARK: - RecursiveSegmentTree

    func test_RecursiveTree1() {
        // Given
        let originalElements = [0, 1, 2]
        let expectedTree = [3, 1, 2, 0, 1]
        let sut = RecursiveSegmentTree(originalElements)
        // Then
        XCTAssertEqual(sut.tree[..<expectedTree.count], expectedTree[...])
    }
    func test_RecursiveTree2() {
        // Given
        let originalElements = [0, 1, 2, 3, 4, 5, 6, 7, 8]
        let expectedTree = [36, 10, 26, 3, 7, 11, 15, 1, 2, 3, 4, 5, 6, 7, 8, 0, 1]
        // When
        let sut = RecursiveSegmentTree(originalElements)
        // Then
        XCTAssertEqual(sut.tree[..<expectedTree.count], expectedTree[...])
    }

    func test_RecursiveTree3() {
        let SUT = RecursiveSegmentTree<Int>.self
        _test_initializesSizeOf0(SUT)
        _test_initializesSizeOf1(SUT)
        _test_initializesFromArrayLiteral(SUT)
        _test_rangeQuery(SUT)
        _test_collection_count(SUT)
        _test_collection_equal(SUT)
        _test_collection_updates(SUT)
    }

    // MARK: - IterativeSegmentTree

    func test_IterativeSegmentTree3() {
        let SUT = IterativeSegmentTree<Int>.self
        _test_initializesSizeOf0(SUT)
        _test_initializesSizeOf1(SUT)
        _test_initializesFromArrayLiteral(SUT)
        _test_rangeQuery(SUT)
        _test_collection_count(SUT)
        _test_collection_equal(SUT)
        _test_collection_updates(SUT)
    }

    // MARK: - Shared

    func _test_initializesSizeOf0<T>(_ SUT: SegmentTreeType<T>, line: UInt = #line)  {
        // Given
        let sut: T = []
        // Then
        XCTAssertEqual(sut.count, 0, line: line)
        XCTAssertEqual(Array(sut), [], line: line)
    }

    func _test_initializesSizeOf1<T>(_ SUT: SegmentTreeType<T>, line: UInt = #line)  {
        // Given
        let sut: T = [101]
        // Then
        XCTAssertEqual(sut.count, 1, line: line)
        XCTAssertEqual(Array(sut), [101], line: line)
    }

    func _test_initializesFromArrayLiteral<T>(_ SUT: SegmentTreeType<T>, line: UInt = #line)  {
        // Given
        let sut: T = [0, 1, 2]
        // Then
        XCTAssertEqual(sut.count, 3, line: line)
        XCTAssertEqual(Array(sut), [0, 1, 2], line: line)
    }

    func _test_rangeQuery<T>(_ SUT: SegmentTreeType<T>, line: UInt = #line)  {
        // Given
        let originalElements = [0, 1, 2, 3, 4, 5, 6, 7, 8]
        let sut = SUT.init(originalElements)
        // Then
        XCTAssertEqual(sut.rangeQuery(in: 0...0), 0, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...1), 1, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...2), 3, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...3), 6, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...4), 10, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...5), 15, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...6), 21, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...7), 28, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 0...8), 36, line: line)

        XCTAssertEqual(sut.rangeQuery(in: 1...1), 1, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 1...2), 3, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 1...3), 6, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 1...4), 10, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 1...5), 15, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 1...6), 21, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 1...7), 28, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 1...8), 36, line: line)

        XCTAssertEqual(sut.rangeQuery(in: 2...2), 2, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 2...3), 5, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 2...4), 9, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 2...5), 14, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 2...6), 20, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 2...7), 27, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 2...8), 35, line: line)

        XCTAssertEqual(sut.rangeQuery(in: 3...3), 3, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 3...4), 7, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 3...5), 12, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 3...6), 18, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 3...7), 25, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 3...8), 33, line: line)

        XCTAssertEqual(sut.rangeQuery(in: 4...4), 4, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 4...5), 9, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 4...6), 15, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 4...7), 22, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 4...8), 30, line: line)

        XCTAssertEqual(sut.rangeQuery(in: 5...5), 5, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 5...6), 11, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 5...7), 18, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 5...8), 26, line: line)

        XCTAssertEqual(sut.rangeQuery(in: 6...6), 6, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 6...7), 13, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 6...8), 21, line: line)

        XCTAssertEqual(sut.rangeQuery(in: 7...7), 7, line: line)
        XCTAssertEqual(sut.rangeQuery(in: 7...8), 15, line: line)

        XCTAssertEqual(sut.rangeQuery(in: 8...8), 8, line: line)
    }
    func _test_collection_count<T>(_ SUT: SegmentTreeType<T>, line: UInt = #line)  {
        // Given
        let originalElements = [0, 1, 2, 3, 4, 5, 6, 7, 8]
        let sut = SUT.init(originalElements)
        // Then
        XCTAssertEqual(sut.count, originalElements.count, line: line)
    }
    func _test_collection_equal<T>(_ SUT: SegmentTreeType<T>, line: UInt = #line)  {
        // Given
        let originalElements = [0, 1, 2, 3, 4, 5, 6, 7, 8]
        let sut = SUT.init(originalElements)
        // Then
        XCTAssertEqual(Array(sut), originalElements, line: line)
    }
    func _test_collection_updates<T>(_ SUT: SegmentTreeType<T>, line: UInt = #line)  {
        // Given
        var originalElements = [0, 1, 2, 3, 4, 5, 6, 7, 8]
        var sut = SUT.init(originalElements)
        // When
        for i in 0..<sut.count {
            originalElements[i] = i + 100
            sut[i] = i + 100
            // Then
            XCTAssertEqual(Array(sut), originalElements, "i=\(i)", line: line)
            XCTAssertEqual(sut.rangeQuery(in: 0..<sut.count), originalElements.reduce(0, +), "i=\(i)", line: line)
        }
    }
}
