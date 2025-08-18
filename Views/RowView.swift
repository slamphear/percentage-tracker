//
//  RowView.swift
//  PercentageTracker
//
//  Created by Steven Lamphear on 8/9/25.
//


import SwiftUI

extension RowModel {
    private func setValue(
        at keyPath: ReferenceWritableKeyPath<RowModel, Int>,
        to newValue: Int,
        using undoManager: UndoManager?
    ) {
        let oldValue = self[keyPath: keyPath]
        self[keyPath: keyPath] = newValue
        self.updatePercentage()

        undoManager?.registerUndo(withTarget: self) { target in
            target.setValue(at: keyPath, to: oldValue, using: undoManager)
        }
    }

    private func incrementValue(
        at keyPath: ReferenceWritableKeyPath<RowModel, Int>,
        using undoManager: UndoManager?
    ) {
        let oldValue = self[keyPath: keyPath]
        let newValue = oldValue + 1
        self.setValue(at: keyPath, to: newValue, using: undoManager)
    }

    // MARK: - Public wrappers

    func setCorrect(to value: Int, using undoManager: UndoManager?) {
        self.setValue(at: \.numCorrect, to: value, using: undoManager)
    }

    func incrementCorrect(using undoManager: UndoManager?) {
        self.incrementValue(at: \.numCorrect, using: undoManager)
    }

    func setIncorrect(to value: Int, using undoManager: UndoManager?) {
        self.setValue(at: \.numIncorrect, to: value, using: undoManager)
    }

    func incrementIncorrect(using undoManager: UndoManager?) {
        self.incrementValue(at: \.numIncorrect, using: undoManager)
    }
}

struct RowView: View {
    @Environment(\.undoManager) private var undoManager
    @ObservedObject var rowModel: RowModel

    var body: some View {
        VStack(alignment: .center, spacing: 8){
            Text("\(self.rowModel.label): \(self.getFormattedPercentage())% correct")
                .foregroundStyle(.tint)
                .tint(.accentColor)

            HStack(alignment: .center, spacing: 12) {
                Spacer()

                Button("\(self.rowModel.numCorrect) correct", systemImage: "x.circle.fill", action: {
                    self.rowModel.incrementCorrect(using: self.undoManager)
                })
                .buttonStyle(.bordered)
                .foregroundStyle(.tint)
                .tint(Color.green)

                Button("\(self.rowModel.numIncorrect) incorrect", systemImage: "x.circle.fill", action: {
                    self.rowModel.incrementIncorrect(using: self.undoManager)
                })
                .buttonStyle(.bordered)
                .foregroundStyle(.tint)
                .tint(Color.red)
                
                Spacer()
            }
        }
    }

    func getFormattedPercentage() -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        guard let formattedPercentage = formatter.string(for: self.rowModel.percentage * 100.0) else {
            return "ERROR"
        }

        return formattedPercentage
    }
}
