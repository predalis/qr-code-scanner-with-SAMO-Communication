import XCTest
@testable import QRCodeKeyboardScanner

final class ScannedCodeStoreTests: XCTestCase {
    func testPendingInsertCanBeConsumedOnce() {
        let suite = "test-suite-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defaults.removePersistentDomain(forName: suite)

        let store = ScannedCodeStore(defaults: defaults)
        store.markPendingInsert("ABC123")

        XCTAssertEqual(store.consumePendingInsert(), "ABC123")
        XCTAssertNil(store.consumePendingInsert())
    }
}
