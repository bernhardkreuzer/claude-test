import SwiftUI

struct TodoRowView: View {
    let todo: TodoItem
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Checkbox
            Button(action: onToggle) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(todo.isCompleted ? .green : .gray)
            }
            .buttonStyle(.plain)

            // Prioritaets-Indikator
            RoundedRectangle(cornerRadius: 2)
                .fill(priorityColor)
                .frame(width: 4, height: 40)

            // Inhalt
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title)
                    .font(.body.weight(.medium))
                    .strikethrough(todo.isCompleted)
                    .foregroundStyle(todo.isCompleted ? .secondary : .primary)

                if !todo.description.isEmpty {
                    Text(todo.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                if let dueDate = todo.dueDate {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.caption2)
                        Text(dueDate, style: .date)
                            .font(.caption2)
                    }
                    .foregroundStyle(isDueOrOverdue ? .red : .secondary)
                }
            }

            Spacer()

            // Prioritaets-Label
            Text(todo.priority.label)
                .font(.caption2.weight(.medium))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(priorityColor.opacity(0.15))
                .foregroundStyle(priorityColor)
                .clipShape(Capsule())
        }
        .padding(.vertical, 4)
        .opacity(todo.isCompleted ? 0.7 : 1.0)
    }

    private var priorityColor: Color {
        switch todo.priority {
        case .low: .green
        case .medium: .orange
        case .high: .red
        }
    }

    private var isDueOrOverdue: Bool {
        guard let dueDate = todo.dueDate else { return false }
        return dueDate < Date()
    }
}

#Preview {
    List {
        TodoRowView(
            todo: TodoItem(title: "Beispielaufgabe", description: "Eine Beschreibung", priority: .high, dueDate: Date()),
            onToggle: {}
        )
        TodoRowView(
            todo: TodoItem(title: "Erledigte Aufgabe", isCompleted: true, priority: .low),
            onToggle: {}
        )
    }
}
