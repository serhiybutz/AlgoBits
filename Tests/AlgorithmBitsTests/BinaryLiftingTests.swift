import XCTest
@testable
import AlgorithmBits

final class BinaryLiftingTests: XCTestCase {
    func test_1() {
        // Given

        var sut = BinaryLiftingTable(treeLevels: 4)

        // Populate jumps table providing child-parent relations
        sut.indexise(index: 1, parentIndex: 0)
        sut.indexise(index: 2, parentIndex: 0)
        sut.indexise(index: 3, parentIndex: 1)
        sut.indexise(index: 4, parentIndex: 1)
        sut.indexise(index: 5, parentIndex: 2)
        sut.indexise(index: 6, parentIndex: 2)
        sut.indexise(index: 7, parentIndex: 3)
        sut.indexise(index: 8, parentIndex: 3)
        sut.indexise(index: 9, parentIndex: 4)
        sut.indexise(index: 10, parentIndex: 4)
        sut.indexise(index: 11, parentIndex: 5)
        sut.indexise(index: 12, parentIndex: 5)
        sut.indexise(index: 13, parentIndex: 6)
        sut.indexise(index: 14, parentIndex: 6)

        // Then

        XCTAssertEqual(sut.maxJumps, 2)

        XCTAssertEqual(sut.getAncestor(1, of: 14), 6)
        XCTAssertEqual(sut.getAncestor(2, of: 14), 2)
        XCTAssertEqual(sut.getAncestor(3, of: 14), 0)
        XCTAssertNil(sut.getAncestor(4, of: 14))

        XCTAssertEqual(sut.getAncestor(1, of: 6), 2)
        XCTAssertEqual(sut.getAncestor(2, of: 6), 0)
        XCTAssertNil(sut.getAncestor(3, of: 6))

        XCTAssertEqual(sut.getAncestor(1, of: 2), 0)
        XCTAssertNil(sut.getAncestor(2, of: 2))

        // Then

        XCTAssertEqual(sut.getAncestor(1, of: 7), 3)
        XCTAssertEqual(sut.getAncestor(2, of: 7), 1)
        XCTAssertEqual(sut.getAncestor(3, of: 7), 0)
        XCTAssertNil(sut.getAncestor(4, of: 7))

        XCTAssertEqual(sut.getAncestor(1, of: 3), 1)
        XCTAssertEqual(sut.getAncestor(2, of: 3), 0)
        XCTAssertNil(sut.getAncestor(3, of: 3))

        XCTAssertEqual(sut.getAncestor(1, of: 1), 0)
        XCTAssertNil(sut.getAncestor(2, of: 1))
    }

    func test_2() {
        ///
        ///     0 -
        ///    / \  \
        ///   1   3  5
        ///  / \     |
        /// 2   4    6
        ///     |
        ///     7
        ///    / \
        ///  11   8
        ///       |
        ///       9
        ///       |
        ///       10
        ///
        var tree: [[Int]] = .init(repeating: [], count: 12)
        // node #0
        tree[0] = [1, 3, 5]
        // node #1
        tree[1] = [2, 4]
        // node #4
        tree[4] = [7]
        // node #5
        tree[5] = [6]
        // node #7
        tree[7] = [11, 8]
        // node #8
        tree[8] = [9]
        // node #9
        tree[9] = [10]

        func treeDeepestLevel(_ node: Int = 0, level: Int = 0) -> Int {
            tree[node].map { treeDeepestLevel($0, level: level + 1) }.max() ?? level
        }

        // Given

        var sut = BinaryLiftingTable(treeLevels: treeDeepestLevel() + 1)

        var relations: [(index: Int, parentIndex: Int)] = []

        func indexise(_ node: Int = 0) {
            tree[node].forEach {
                relations.append(($0, node))
                indexise($0)
            }
        }

        indexise()

        relations.sorted(by: { $0.index < $1.index }).forEach { index, parentIndex in
            sut.indexise(index: index, parentIndex: parentIndex)
        }

        // Then

        XCTAssertEqual(sut.treeLevels, 7)
        XCTAssertEqual(sut.maxJumps, 3)

        // Then

        XCTAssertEqual(sut.getAncestor(1, of: 10), 9)
        XCTAssertEqual(sut.getAncestor(2, of: 10), 8)
        XCTAssertEqual(sut.getAncestor(3, of: 10), 7)
        XCTAssertEqual(sut.getAncestor(4, of: 10), 4)
        XCTAssertEqual(sut.getAncestor(5, of: 10), 1)
        XCTAssertEqual(sut.getAncestor(6, of: 10), 0)
        XCTAssertNil(sut.getAncestor(7, of: 10))

        // Then

        XCTAssertEqual(sut.getAncestor(1, of: 9), 8)
        XCTAssertEqual(sut.getAncestor(2, of: 9), 7)
        XCTAssertEqual(sut.getAncestor(3, of: 9), 4)
        XCTAssertEqual(sut.getAncestor(4, of: 9), 1)
        XCTAssertEqual(sut.getAncestor(5, of: 9), 0)
        XCTAssertNil(sut.getAncestor(6, of: 9))

        // Then

        XCTAssertEqual(sut.getAncestor(1, of: 8), 7)
        XCTAssertEqual(sut.getAncestor(2, of: 8), 4)
        XCTAssertEqual(sut.getAncestor(3, of: 8), 1)
        XCTAssertEqual(sut.getAncestor(4, of: 8), 0)
        XCTAssertNil(sut.getAncestor(5, of: 8))

        // Then

        XCTAssertEqual(sut.getAncestor(1, of: 7), 4)
        XCTAssertEqual(sut.getAncestor(2, of: 7), 1)
        XCTAssertEqual(sut.getAncestor(3, of: 7), 0)
        XCTAssertNil(sut.getAncestor(4, of: 7))

        // Then

        XCTAssertEqual(sut.getAncestor(1, of: 4), 1)
        XCTAssertEqual(sut.getAncestor(2, of: 4), 0)
        XCTAssertNil(sut.getAncestor(3, of: 4))

        // Then

        XCTAssertEqual(sut.getAncestor(1, of: 1), 0)
        XCTAssertNil(sut.getAncestor(2, of: 1))

        // Then

        XCTAssertEqual(sut.getAncestor(1, of: 11), 7)
        XCTAssertEqual(sut.getAncestor(2, of: 11), 4)
        XCTAssertEqual(sut.getAncestor(3, of: 11), 1)
        XCTAssertEqual(sut.getAncestor(4, of: 11), 0)
        XCTAssertNil(sut.getAncestor(5, of: 11))

        // Then

        XCTAssertEqual(sut.getAncestor(1, of: 2), 1)
        XCTAssertEqual(sut.getAncestor(2, of: 2), 0)
        XCTAssertNil(sut.getAncestor(3, of: 2))

        // Then

        XCTAssertEqual(sut.getAncestor(1, of: 3), 0)
        XCTAssertNil(sut.getAncestor(2, of: 3))

        // Then

        XCTAssertEqual(sut.getAncestor(1, of: 6), 5)
        XCTAssertEqual(sut.getAncestor(2, of: 6), 0)
        XCTAssertNil(sut.getAncestor(3, of: 6))

        // Then

        XCTAssertEqual(sut.getAncestor(1, of: 5), 0)
        XCTAssertNil(sut.getAncestor(2, of: 5))
    }
}
