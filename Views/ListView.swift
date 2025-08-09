//
//  ListView.swift
//  PercentageTracker
//
//  Created by Steven Lamphear on 8/9/25.
//

import SwiftUI

struct ListView: View {
    @State var rows: Array<RowModel> = []
    @State var newRowTitle: String = ""
    @State var isCreatingNewRow: Bool = false
    
    var body: some View {
        List {
            ForEach(self.rows) { row in
                Section {
                    RowView(rowModel: row)
                    .listRowInsets(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
                }
            }
            .onDelete(perform: delete)
            .listStyle(.insetGrouped)
            .scaledToFill()
        }
        .navigationTitle(Text("Percentage Tracker"))
        .toolbar {
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
                        self.rows.append(
                            .init(label: self.newRowTitle, numCorrect: 0, numIncorrect: 0, percentage: 0.0)
                        )
                        self.newRowTitle = ""
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
    
    func delete(at offsets: IndexSet) {
        self.rows.remove(atOffsets: offsets)
    }
}

#Preview {
    ListView(
        rows: [
            .init(label: "Example 1", numCorrect: 1, numIncorrect: 4, percentage: 0.2),
            .init(label: "Example 2", numCorrect: 4, numIncorrect: 1, percentage: 0.8)
        ]
    )
}
