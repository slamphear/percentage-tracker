//
//  RowView.swift
//  PercentageTracker
//
//  Created by Steven Lamphear on 8/9/25.
//


import SwiftUI

struct RowView: View {
    @State var rowModel: RowModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 8){
            Text("\(self.rowModel.label): \(self.getFormattedPercentage())% correct")

            HStack(alignment: .center, spacing: 12) {
                Spacer()
                
                Button("\(self.rowModel.numCorrect) correct", systemImage: "x.circle.fill", action: {
                    self.rowModel.numCorrect += 1
                    self.updatePercentage()
                })
                .buttonStyle(.bordered)
                .foregroundStyle(.tint)
                .tint(Color.green)
                
                
                Button("\(self.rowModel.numIncorrect) incorrect", systemImage: "x.circle.fill", action: {
                    self.rowModel.numIncorrect += 1
                    self.updatePercentage()
                })
                .buttonStyle(.bordered)
                .foregroundStyle(.tint)
                .tint(Color.red)
                
                Spacer()
            }
        }
    }
    
    func updatePercentage() {
        let total = Decimal(self.rowModel.numCorrect + self.rowModel.numIncorrect)
        self.rowModel.percentage = Decimal(self.rowModel.numCorrect) / total
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
