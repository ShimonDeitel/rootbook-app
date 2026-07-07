import Foundation

struct Propagation: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var plantName: String
    var method: String
    var dateStarted: Date
    var status: String

    init(id: UUID = UUID(), plantName: String = "", method: String = "", dateStarted: Date = Date(), status: String = "") {
        self.id = id
        self.plantName = plantName
        self.method = method
        self.dateStarted = dateStarted
        self.status = status
    }
}
