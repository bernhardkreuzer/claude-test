import Foundation
import SwiftUI

@Observable
class TodoViewModel {
    var todos: [TodoItem] = []
    var searchText: String = ""
    var selectedFilter: Filter = .all

    enum Filter: String, CaseIterable {
        case all = "Alle"
        case pending = "Offen"
        case completed = "Erledigt"
    }

    var filteredTodos: [TodoItem] {
        var result = todos

        switch selectedFilter {
        case .all:
            break
        case .pending:
            result = result.filter { !$0.isCompleted }
        case .completed:
            result = result.filter { $0.isCompleted }
        }

        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }

        return result.sorted { $0.priority > $1.priority }
    }

    var completedCount: Int {
        todos.filter(\.isCompleted).count
    }

    var pendingCount: Int {
        todos.filter { !$0.isCompleted }.count
    }

    private let storageKey = "saved_todos"

    init() {
        loadTodos()
    }

    func addTodo(_ todo: TodoItem) {
        todos.append(todo)
        saveTodos()
    }

    func deleteTodo(at offsets: IndexSet) {
        let todosToDelete = offsets.map { filteredTodos[$0] }
        todos.removeAll { todo in todosToDelete.contains { $0.id == todo.id } }
        saveTodos()
    }

    func toggleCompletion(for todo: TodoItem) {
        guard let index = todos.firstIndex(where: { $0.id == todo.id }) else { return }
        todos[index].isCompleted.toggle()
        saveTodos()
    }

    func updateTodo(_ todo: TodoItem) {
        guard let index = todos.firstIndex(where: { $0.id == todo.id }) else { return }
        todos[index] = todo
        saveTodos()
    }

    private func saveTodos() {
        if let data = try? JSONEncoder().encode(todos) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func loadTodos() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([TodoItem].self, from: data) else { return }
        todos = decoded
    }
}
