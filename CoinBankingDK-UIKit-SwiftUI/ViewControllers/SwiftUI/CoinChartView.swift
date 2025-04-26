//
//  CoinChartView.swift
//  CoinBankingDK-UIKit-SwiftUI
//
//  Created by Daniel Kimani on 26/04/2025.
//

import SwiftUI
import Charts


struct CoinChartView: View {
    let coin: Coin
    
    // Clean non-nil sparkline values
    var sparklineValues: [Double] {
        coin.sparkline?.compactMap { Double($0 ?? "") } ?? []
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
          
            Chart {
                ForEach(Array(sparklineValues.enumerated()), id: \.offset) { index, value in
                    LineMark(
                        x: .value("Time", index),
                        y: .value("Price", value)
                    )
                    .foregroundStyle(Color(hex: coin.color ?? "#f7931A"))
                    .interpolationMethod(.catmullRom)
                }
            }
            .chartXAxis {
                AxisMarks(values: .automatic) { value in
                    AxisGridLine()
                    AxisValueLabel()
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading, values: .automatic) { value in
                    AxisGridLine()
                    AxisValueLabel()
                    //AxisValueLabel(format: .currency(code: "USD"))//.precision(.fractionDigits(2)))
                }
            }
            //.chartLegend(position: .bottom, alignment: .bottom, spacing: .greatestFiniteMagnitude)
            .chartLegend(position: .bottom, alignment: .leading) {
                Text("Price")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .background(Color(.systemGray6))
        }
        .padding()
    }
}

struct SimpleCoinChartView: View {
    let coin: Coin

    // Clean non-nil sparkline values
    var sparklineValues: [Double] {
        coin.sparkline?.compactMap { Double($0 ?? "") } ?? []
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
           
            Chart {
                ForEach(Array(sparklineValues.enumerated()), id: \.offset) { index, value in
                    LineMark(
                        x: .value("Time", index),
                        y: .value("Price", value)
                    )
                    .foregroundStyle(Color(hex: coin.color ?? "#f7931A"))
                    .interpolationMethod(.catmullRom)
                }
            }
            .background(Color(.systemGray6))
        }
        .padding()
    }
}




// Helper extension to convert HEX to SwiftUI Color
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, (int >> 16) & 0xff, (int >> 8) & 0xff, int & 0xff)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = ((int >> 24) & 0xff, (int >> 16) & 0xff, (int >> 8) & 0xff, int & 0xff)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
