//
//  UndoManagerObserver.swift
//  PercentageTracker
//
//  Created by Steven Lamphear on 8/17/25.
//

import Combine
import Foundation

final class UndoManagerObserver: ObservableObject {
    @Published var canUndo = false
    @Published var canRedo = false

    private var cancellables: [AnyCancellable] = []
    private weak var undoManager: UndoManager?

    func attach(to undoManager: UndoManager?) {
        self.undoManager = undoManager
        updateState()

        cancellables.removeAll()

        guard let undoManager else { return }

        NotificationCenter.default.publisher(for: .NSUndoManagerDidUndoChange, object: undoManager)
            .merge(with:
                NotificationCenter.default.publisher(for: .NSUndoManagerDidRedoChange, object: undoManager),
                NotificationCenter.default.publisher(for: .NSUndoManagerWillCloseUndoGroup, object: undoManager)
            )
            .sink { [weak self] _ in self?.updateState() }
            .store(in: &cancellables)
    }

    private func updateState() {
        canUndo = undoManager?.canUndo ?? false
        canRedo = undoManager?.canRedo ?? false
    }
}
