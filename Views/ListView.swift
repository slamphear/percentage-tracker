//
//  ListView.swift
//  PercentageTracker
//
//  Created by Steven Lamphear on 8/9/25.
//

import SwiftUI

extension ListModel {
    func addRow(_ row: RowModel, using undoManager: UndoManager?) {
        self.rows.append(row)

        undoManager?.registerUndo(withTarget: self) { target in
            target.removeLastRow(using: undoManager)
        }
    }

    func removeLastRow(using undoManager: UndoManager?) {
        guard let last = self.rows.popLast() else { return }

        undoManager?.registerUndo(withTarget: self) { target in
            target.addRow(last, using: undoManager)
        }
    }

    func delete(at offsets: IndexSet, using undoManager: UndoManager?) {
        let removed = offsets.map { rows[$0] }
        self.rows.remove(atOffsets: offsets)

        undoManager?.registerUndo(withTarget: self) { target in
            target.insert(removed, at: offsets, using: undoManager)
        }
    }

    func insert(_ items: [RowModel], at offsets: IndexSet, using undoManager: UndoManager?) {
        for (i, offset) in offsets.enumerated() {
            self.rows.insert(items[i], at: offset)
        }

        undoManager?.registerUndo(withTarget: self) { target in
            target.delete(at: offsets, using: undoManager)
        }
    }
}

struct ListView: View {
    @Environment(\.undoManager) private var undoManager
    @ObservedObject var listModel: ListModel
    @State var newRowTitle: String = ""
    @State var isCreatingNewRow: Bool = false
    @StateObject private var undoObserver: UndoManagerObserver = .init()

    var body: some View {
        List {
            ForEach(self.listModel.rows) { row in
                Section {
                    RowView(rowModel: row)
                    .listRowInsets(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
                }
            }
            .onDelete { offsets in
                self.listModel.delete(at: offsets, using: self.undoManager)
            }
            .listStyle(.insetGrouped)
            .scaledToFill()
        }
        .onAppear {
            self.undoObserver.attach(to: self.undoManager)
        }
        .navigationTitle(Text("Percentage Tracker"))
        .toolbar {
            Button("Undo", systemImage: "arrow.uturn.backward") {
                self.undoManager?.undo()
            }
            .disabled(!undoObserver.canUndo)

            Button("Redo", systemImage: "arrow.uturn.forward") {
                self.undoManager?.redo()
            }
            .disabled(!undoObserver.canRedo)

            EditButton()

            Button("Create", systemImage: "plus") {
                self.isCreatingNewRow = true
            }
        }
        .alert(
            "Enter a label",
            isPresented: self.$isCreatingNewRow,
            actions: {
                TextField("", text: self.$newRowTitle)

                Button(
                    "Accept",
                    action: {
                        let newRow = RowModel(
                            label: newRowTitle,
                            numCorrect: 0,
                            numIncorrect: 0,
                            percentage: 0.0
                        )
                        self.listModel.addRow(newRow, using: self.undoManager)
                        newRowTitle = ""
                    }
                )
                Button(
                    "Cancel",
                    role: .cancel,
                    action: {
                        self.newRowTitle = ""
                    }
                )
            }
        ) {
            Text("Enter a label for the new row")
        }
    }
}

#Preview {
    ListView(listModel: .init(
            rows: [
                .init(label: "Example 1", numCorrect: 1, numIncorrect: 4, percentage: 0.2),
                .init(label: "Example 2", numCorrect: 4, numIncorrect: 1, percentage: 0.8)
            ]
        )
    )
}
