import SwiftUI

struct TodoListView: View {
    @State private var viewModel = TodoViewModel()
    @State private var showingAddSheet = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Statistik-Header
                HStack(spacing: 20) {
                    StatBadge(label: "Offen", count: viewModel.pendingCount, color: .orange)
                    StatBadge(label: "Erledigt", count: viewModel.completedCount, color: .green)
                    StatBadge(label: "Gesamt", count: viewModel.todos.count, color: .blue)
                }
                .padding()
                .background(.ultraThinMaterial)

                // Filter
                Picker("Filter", selection: $viewModel.selectedFilter) {
                    ForEach(TodoViewModel.Filter.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.vertical, 8)

                // Aufgabenliste
                if viewModel.filteredTodos.isEmpty {
                    ContentUnavailableView {
                        Label("Keine Aufgaben", systemImage: "checklist")
                    } description: {
                        Text("Tippe auf '+' um eine neue Aufgabe hinzuzufuegen.")
                    }
                } else {
                    List {
                        ForEach(viewModel.filteredTodos) { todo in
                            TodoRowView(todo: todo) {
                                viewModel.toggleCompletion(for: todo)
                            }
                        }
                        .onDelete(perform: viewModel.deleteTodo)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Aufgaben")
            .searchable(text: $viewModel.searchText, prompt: "Aufgaben durchsuchen...")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddTodoView { newTodo in
                    viewModel.addTodo(newTodo)
                }
            }
        }
    }
}

struct StatBadge: View {
    let label: String
    let count: Int
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.title2.bold())
                .foregroundStyle(color)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    TodoListView()
}
