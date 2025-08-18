//
//  RowModel.swift
//  PercentageTracker
//
//  Created by Steven Lamphear on 8/9/25.
//

import Foundation

final class RowModel: ObservableObject, Identifiable {
    let id: UUID
    var label: String
    @Published var numCorrect: Int
    @Published var numIncorrect: Int
    @Published var percentage: Decimal

    public init(label: String, numCorrect: Int, numIncorrect: Int, percentage: Decimal) {
        self.id = .init()
        self.label = label
        self.numCorrect = numCorrect
        self.numIncorrect = numIncorrect
        self.percentage = percentage
    }

    func updatePercentage() {
        let total = Decimal(self.numCorrect + self.numIncorrect)

        if total <= 0 {
            self.percentage = total
            return
        }

        self.percentage = Decimal(self.numCorrect) / total
    }
}
