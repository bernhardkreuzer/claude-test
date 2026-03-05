import Foundation

struct TodoItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var isCompleted: Bool
    var priority: Priority
    var createdAt: Date
    var dueDate: Date?

    enum Priority: Int, Codable, CaseIterable, Comparable {
        case low = 0
        case medium = 1
        case high = 2

        var label: String {
            switch self {
            case .low: "Niedrig"
            case .medium: "Mittel"
            case .high: "Hoch"
            }
        }

        var color: String {
            switch self {
            case .low: "green"
            case .medium: "orange"
            case .high: "red"
            }
        }

        static func < (lhs: Priority, rhs: Priority) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }

    init(
        id: UUID = UUID(),
        title: String,
        description: String = "",
        isCompleted: Bool = false,
        priority: Priority = .medium,
        createdAt: Date = Date(),
        dueDate: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.priority = priority
        self.createdAt = createdAt
        self.dueDate = dueDate
    }
}
