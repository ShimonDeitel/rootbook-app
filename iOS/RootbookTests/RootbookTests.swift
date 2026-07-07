import XCTest
@testable import Rootbook

@MainActor
final class RootbookTests: XCTestCase {
    func makeIsolatedStore() -> Store {
        Store()
    }

    func testSeedDataUnderFreeLimit() {
        let store = makeIsolatedStore()
        XCTAssertLessThan(Store.seedData().count, Store.freeLimit)
    }

    func testAddIncreasesCount() {
        let store = makeIsolatedStore()
        let before = store.items.count
        let added = store.add(Propagation())
        XCTAssertTrue(added)
        XCTAssertEqual(store.items.count, before + 1)
    }

    func testDeleteRemovesItem() {
        let store = makeIsolatedStore()
        let item = Propagation()
        store.add(item)
        store.delete(item)
        XCTAssertFalse(store.items.contains(item))
    }

    func testCanAddMoreWhenUnderLimit() {
        let store = makeIsolatedStore()
        store.items = []
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreAtLimitWhenNotPro() {
        let store = makeIsolatedStore()
        store.isPro = false
        store.items = Array(repeating: Propagation(), count: Store.freeLimit)
        XCTAssertFalse(store.canAddMore)
        XCTAssertFalse(store.add(Propagation()))
    }

    func testProBypassesLimit() {
        let store = makeIsolatedStore()
        store.isPro = true
        store.items = Array(repeating: Propagation(), count: Store.freeLimit)
        XCTAssertTrue(store.canAddMore)
        XCTAssertTrue(store.add(Propagation()))
    }

    func testUpdateModifiesExistingItem() {
        let store = makeIsolatedStore()
        var item = Propagation()
        store.add(item)
        item.plantName = "Updated"
        store.update(item)
        XCTAssertEqual(store.items.first(where: { $0.id == item.id })?.plantName, "Updated")
    }

    func testDeleteAtOffsets() {
        let store = makeIsolatedStore()
        store.items = [Propagation(), Propagation()]
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.items.count, 1)
    }
}
