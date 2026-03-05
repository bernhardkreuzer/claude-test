import SwiftUI

struct AddTodoView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var description = ""
    @State private var priority: TodoItem.Priority = .medium
    @State private var hasDueDate = false
    @State private var dueDate = Date()

    let onAdd: (TodoItem) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Aufgabe") {
                    TextField("Titel", text: $title)
                        .font(.headline)

                    TextField("Beschreibung (optional)", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section("Prioritaet") {
                    Picker("Prioritaet", selection: $priority) {
                        ForEach(TodoItem.Priority.allCases, id: \.self) { priority in
                            HStack {
                                Circle()
                                    .fill(colorForPriority(priority))
                                    .frame(width: 10, height: 10)
                                Text(priority.label)
                            }
                            .tag(priority)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Faelligkeitsdatum") {
                    Toggle("Faelligkeitsdatum setzen", isOn: $hasDueDate.animation())

                    if hasDueDate {
                        DatePicker(
                            "Faellig am",
                            selection: $dueDate,
                            in: Date()...,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                    }
                }
            }
            .navigationTitle("Neue Aufgabe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Speichern") {
                        let todo = TodoItem(
                            title: title,
                            description: description,
                            priority: priority,
                            dueDate: hasDueDate ? dueDate : nil
                        )
                        onAdd(todo)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                    .bold()
                }
            }
        }
    }

    private func colorForPriority(_ priority: TodoItem.Priority) -> Color {
        switch priority {
        case .low: .green
        case .medium: .orange
        case .high: .red
        }
    }
}

#Preview {
    AddTodoView { _ in }
}
