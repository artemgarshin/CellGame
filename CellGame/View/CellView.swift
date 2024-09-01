//
//  CellView.swift
//  CellGame
//
//  Created by Артем Гаршин on 31.08.2024.
//

import SwiftUI

struct CellView: View {
    let cell: Cell
    let animateMerging: Bool
    let mergeIndexes: [Int]
    let index: Int

    var body: some View {
        HStack {
            cellIcon(for: cell)
            Text(cell.rawValue)
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .gray, radius: 2, x: 0, y: 5)
        .offset(x: animateMerging && mergeIndexes.contains(index) ? CGFloat(mergeIndexes.firstIndex(of: index) ?? 0) * -20 : 0)
        .opacity(animateMerging && mergeIndexes.contains(index) ? 0.0 : 1.0)
        .animation(.easeInOut(duration: 0.5), value: animateMerging)
    }

    @ViewBuilder
    func cellIcon(for cell: Cell) -> some View {
        switch cell {
        case .dead:
            Image("deadIcon")
                .resizable()
                .frame(width: 24, height: 24)
        case .alive:
            Image("aliveIcon")
                .resizable()
                .frame(width: 24, height: 24)
        case .life:
            Image("lifeIcon")
                .resizable()
                .frame(width: 24, height: 24)
        }
    }
}
