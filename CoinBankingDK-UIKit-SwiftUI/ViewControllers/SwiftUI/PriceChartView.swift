//
//  PriceChartView.swift
//  CoinBankingDK-UIKit-SwiftUI
//
//  Created by Daniel Kimani on 26/04/2025.
//
// SwiftUI/PriceChartView.swift
import SwiftUI
import WebKit
import Charts

struct PriceChartView: UIViewRepresentable {
    let sparklineData: [String?]
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.backgroundColor = .systemBackground
        webView.isOpaque = false
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let chartData = sparklineData.compactMap { Double($0 ?? "") }
        let formattedData = chartData.enumerated().map { (index, value) -> [String: Any] in
            return ["date": index, "price": value]
        }
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: formattedData),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return
        }
        
        // Create basic chart using D3.js
        let htmlString = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <script src="https://cdnjs.cloudflare.com/ajax/libs/d3/7.0.0/d3.min.js"></script>
            <style>
                body { margin: 0; padding: 0; font-family: -apple-system, system-ui; }
                .line { fill: none; stroke: #4CAF50; stroke-width: 2; }
                .area { fill: rgba(76, 175, 80, 0.2); }
                .axis { font-size: 12px; }
                .axis line, .axis path { stroke: #ccc; }
            </style>
        </head>
        <body>
            <div id="chart"></div>
            <script>
                const data = \(jsonString);
                
                const margin = {top: 20, right: 20, bottom: 30, left: 50};
                const width = window.innerWidth - margin.left - margin.right - 40;
                const height = 250 - margin.top - margin.bottom;
                
                const svg = d3.select("#chart")
                    .append("svg")
                    .attr("width", width + margin.left + margin.right)
                    .attr("height", height + margin.top + margin.bottom)
                    .append("g")
                    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
                
                const x = d3.scaleLinear()
                    .domain([0, data.length - 1])
                    .range([0, width]);
                
                const y = d3.scaleLinear()
                    .domain([d3.min(data, d => d.price) * 0.95, d3.max(data, d => d.price) * 1.05])
                    .range([height, 0]);
                
                const line = d3.line()
                    .x(d => x(d.date))
                    .y(d => y(d.price))
                    .curve(d3.curveMonotoneX);
                
                const area = d3.area()
                    .x(d => x(d.date))
                    .y0(height)
                    .y1(d => y(d.price))
                    .curve(d3.curveMonotoneX);
                
                svg.append("path")
                    .datum(data)
                    .attr("class", "area")
                    .attr("d", area);
                
                svg.append("path")
                    .datum(data)
                    .attr("class", "line")
                    .attr("d", line);
                
                svg.append("g")
                    .attr("class", "axis")
                    .attr("transform", "translate(0," + height + ")")
                    .call(d3.axisBottom(x).ticks(5).tickFormat(d => `${d}h`));
                
                svg.append("g")
                    .attr("class", "axis")
                    .call(d3.axisLeft(y).ticks(5));
            </script>
        </body>
        </html>
        """
        
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
}



