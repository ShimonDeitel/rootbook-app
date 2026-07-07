import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [Propagation] = []
    @Published var isPro: Bool = false

    /// Free tier allows this many entries. Seed data below is always fewer than this
    /// so a fresh install never opens straight into the paywall.
    static let freeLimit = 20

    private let fileName = "rootbook_items.json"

    private var fileURL: URL {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir.appendingPathComponent(fileName)
    }

    init() {
        load()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([Propagation].self, from: data) else {
            items = Self.seedData()
            save()
            return
        }
        items = decoded
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    var canAddMore: Bool {
        isPro || items.count < Self.freeLimit
    }

    @discardableResult
    func add(_ item: Propagation) -> Bool {
        guard canAddMore else { return false }
        items.append(item)
        save()
        return true
    }

    func update(_ item: Propagation) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Propagation) {
        items.removeAll { $0.id == item.id }
        save()
    }

    static func seedData() -> [Propagation] {
        [
        Propagation(plantName: "Monstera", method: "Wire Brush", dateStarted: Date().addingTimeInterval(-259200), status: "Pending"),
        Propagation(plantName: "Pothos", method: "Vinegar Soak", dateStarted: Date().addingTimeInterval(-518400), status: "Rooted"),
        Propagation(plantName: "Snake Plant", method: "Cutting", dateStarted: Date().addingTimeInterval(-777600), status: "Failed"),
        Propagation(plantName: "Fiddle Leaf Fig", method: "Division", dateStarted: Date().addingTimeInterval(-1036800), status: "Pending")
        ]
    }
}
