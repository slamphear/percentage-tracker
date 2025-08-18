//
//  ListModel.swift
//  PercentageTracker
//
//  Created by Steven Lamphear on 8/17/25.
//

import Foundation

final class ListModel: ObservableObject, Identifiable {
    @Published var rows: [RowModel] = []
    
    public init(rows: [RowModel]) {
        self.rows = rows
    }
}
