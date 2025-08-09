//
//  RowModel.swift
//  PercentageTracker
//
//  Created by Steven Lamphear on 8/9/25.
//

import Foundation

struct RowModel: Identifiable {
    var id: UUID
    var isInEditMode: Bool
    var label: String
    var numCorrect: Int
    var numIncorrect: Int
    var percentage: Decimal
}

extension RowModel {
    public init(label: String, numCorrect: Int, numIncorrect: Int, percentage: Decimal) {
        self.id = UUID()
        self.isInEditMode = false
        self.label = label
        self.numCorrect = numCorrect
        self.numIncorrect = numIncorrect
        self.percentage = percentage
    }
}
