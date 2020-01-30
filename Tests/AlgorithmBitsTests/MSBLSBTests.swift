import XCTest
@testable
import AlgorithmBits

final class MSBLSBTests: XCTestCase {
    func test_minus1() {
        // Given
        let v: Int = -1
        // Then
        XCTAssertNil(v.MSBIndex)
        XCTAssertNil(v.MSBIndex2)
        // Then
        XCTAssertNil(v.MSB)
        XCTAssertNil(v.LSB)
    }
    func test_0() {
        // Given
        let v: Int = 0
        // Then
        XCTAssertNil(v.MSBIndex)
        XCTAssertNil(v.MSBIndex2)
        // Then
        XCTAssertNil(v.MSB)
        XCTAssertNil(v.LSB)
    }
    func test_1() {
        // Given
        let v: Int = 1
        let expectedIndex: Int32? = 0
        let expectedMSB: Int? = 1
        let expectedLSB: Int? = 1
        // Then
        XCTAssertEqual(v.MSBIndex, expectedIndex)
        XCTAssertEqual(v.MSBIndex2, Int(expectedIndex!))
        // Then
        XCTAssertEqual(v.MSB, expectedMSB)
        XCTAssertEqual(v.LSB, expectedLSB)
    }
    func test_2() {
        // Given
        let v: Int = 2
        let expectedIndex: Int32? = 1
        let expectedMSB: Int? = 2
        let expectedLSB: Int? = 2
        // Then
        XCTAssertEqual(v.MSBIndex, expectedIndex)
        XCTAssertEqual(v.MSBIndex2, Int(expectedIndex!))
        // Then
        XCTAssertEqual(v.MSB, expectedMSB)
        XCTAssertEqual(v.LSB, expectedLSB)
    }
    func test_3() {
        // Given
        let v: Int = 3
        let expectedIndex: Int32? = 1
        let expectedMSB: Int? = 2
        let expectedLSB: Int? = 1
        // Then
        XCTAssertEqual(v.MSBIndex, expectedIndex)
        XCTAssertEqual(v.MSBIndex2, Int(expectedIndex!))
        // Then
        XCTAssertEqual(v.MSB, expectedMSB)
        XCTAssertEqual(v.LSB, expectedLSB)
    }
    func test_4() {
        // Given
        let v: Int = 4
        let expectedIndex: Int32? = 2
        let expectedMSB: Int? = 4
        let expectedLSB: Int? = 4
        // Then
        XCTAssertEqual(v.MSBIndex, expectedIndex)
        XCTAssertEqual(v.MSBIndex2, Int(expectedIndex!))
        // Then
        XCTAssertEqual(v.MSB, expectedMSB)
        XCTAssertEqual(v.LSB, expectedLSB)
    }
    func test_5() {
        // Given
        let v: Int = 5
        let expectedIndex: Int32? = 2
        let expectedMSB: Int? = 4
        let expectedLSB: Int? = 1
        // Then
        XCTAssertEqual(v.MSBIndex, expectedIndex)
        XCTAssertEqual(v.MSBIndex2, Int(expectedIndex!))
        // Then
        XCTAssertEqual(v.MSB, expectedMSB)
        XCTAssertEqual(v.LSB, expectedLSB)
    }
    func test_6() {
        // Given
        let v: Int = 6
        let expectedIndex: Int32? = 2
        let expectedMSB: Int? = 4
        let expectedLSB: Int? = 2
        // Then
        XCTAssertEqual(v.MSBIndex, expectedIndex)
        XCTAssertEqual(v.MSBIndex2, Int(expectedIndex!))
        // Then
        XCTAssertEqual(v.MSB, expectedMSB)
        XCTAssertEqual(v.LSB, expectedLSB)
    }
    func test_7() {
        // Given
        let v: Int = 7
        let expectedIndex: Int32? = 2
        let expectedMSB: Int? = 4
        let expectedLSB: Int? = 1
        // Then
        XCTAssertEqual(v.MSBIndex, expectedIndex)
        XCTAssertEqual(v.MSBIndex2, Int(expectedIndex!))
        // Then
        XCTAssertEqual(v.MSB, expectedMSB)
        XCTAssertEqual(v.LSB, expectedLSB)
    }
    func test_8() {
        // Given
        let v: Int = 8
        let expectedIndex: Int32? = 3
        let expectedMSB: Int? = 8
        let expectedLSB: Int? = 8
        // Then
        XCTAssertEqual(v.MSBIndex, expectedIndex)
        XCTAssertEqual(v.MSBIndex2, Int(expectedIndex!))
        // Then
        XCTAssertEqual(v.MSB, expectedMSB)
        XCTAssertEqual(v.LSB, expectedLSB)
    }
    func test_9() {
        // Given
        let v: Int = 9
        let expectedIndex: Int32? = 3
        let expectedMSB: Int? = 8
        let expectedLSB: Int? = 1
        // Then
        XCTAssertEqual(v.MSBIndex, expectedIndex)
        XCTAssertEqual(v.MSBIndex2, Int(expectedIndex!))
        // Then
        XCTAssertEqual(v.MSB, expectedMSB)
        XCTAssertEqual(v.LSB, expectedLSB)
    }
}
