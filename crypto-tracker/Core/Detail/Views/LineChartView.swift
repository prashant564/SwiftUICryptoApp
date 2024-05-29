//
//  LineChartView.swift
//  crypto-tracker
//
//  Created by PrashantDixit on 26/05/24.
//

import SwiftUI

struct LineChartView: View {
    
//    private let coin: CoinModel
    private let data: [Double]
    private let minY: Double
    private let maxY: Double
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date
    @State private var percentage: CGFloat = 0
    
    init(coin: CoinModel) {
        self.data = coin.sparklineIn7D?.price ?? []
        minY = data.min() ?? 0
        maxY = data.max() ?? 0
        
        let pricePercentChange =  coin.priceChangePercentage24H
        lineColor = pricePercentChange ?? 0.0 > 0 ? Color.theme.green : Color.theme.red
        
        endingDate = Date(timestamp: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7*24*60*60)
    }
    
    var body: some View {
        VStack {
            GeometryReader(content: { geometry in
                Path { path in
                    
                    for index in data.indices {
                        // 300 -> width
                        // 100 -> length of data
                        // 3 -> each x coord
                        let xPosition = (geometry.size.width / CGFloat(data.count)) * CGFloat(index + 1)
                        
                        let yRange = maxY - minY
                        // in ios y coordinate is 0 from bottom so subtract by 1
                        let yPosition = (1 - CGFloat((data[index] - minY)/yRange)) * geometry.size.height
                        
                        if(index == 0) {
                            path.move(to: CGPoint(x: xPosition, y: yPosition))
                        }
                        
                        path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                        
                    }
                }
                //for animating graph progress
                .trim(from: 0.0, to: percentage)
                .stroke(lineColor ,style: StrokeStyle( lineWidth: 2, lineCap: .round, lineJoin: .round ))
                //for adding shadow
                .shadow(color: lineColor, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/ , x: 0.0, y: 10)
                .shadow(color: lineColor.opacity(0.5), radius: 10 , x: 0.0, y: 20)
                .shadow(color: lineColor.opacity(0.2), radius: 10 , x: 0.0, y: 30)
                .shadow(color: lineColor.opacity(0.1), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/ , x: 0.0, y: 40)
            })
            .frame(height: 200)
            .background {
                VStack {
                    Divider()
                    Spacer()
                    Divider()
                    Spacer()
                    Divider()
                }
                .overlay(alignment: .leading) {
                    VStack {
                        Text("\(maxY.formattedWithAbbreviations())")
                        Spacer()
                        let midY = (maxY + minY) / 2
                        Text("\(midY.formattedWithAbbreviations())")
                        Spacer()
                        Text("\(minY.formattedWithAbbreviations())")
                    }
                    .font(.caption)
                    .foregroundStyle(Color.theme.secondaryText)
                    .padding(.horizontal, 4)
                }
                
            }
            
            HStack {
                Text("\(startingDate.asShortDateString())")
                Spacer()
                Text("\(endingDate.asShortDateString())")
            }
            .font(.caption)
            .foregroundStyle(Color.theme.secondaryText)
            .padding(.horizontal, 4)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 3.0)) {
                    percentage = 1.0
                }
            }
        }
    }
}

struct LineChartView_Previews: PreviewProvider {
    static var previews: some View {
        LineChartView(coin: dev.coin)
    }
}
