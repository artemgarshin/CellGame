//
//  ContentView.swift
//  CellGame
//
//  Created by Артем Гаршин on 31.08.2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = CellsViewModel()
    
    @State private var animateMerging = false
    @State private var mergeIndexes: [Int] = []
    @State private var lastVisibleCellIndex: Int? = nil

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.black]),
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(viewModel.cells.indices, id: \.self) { index in
                                CellView(cell: viewModel.cells[index],
                                         animateMerging: animateMerging,
                                         mergeIndexes: mergeIndexes,
                                         index: index)
                                    .id(index)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .onChange(of: viewModel.cells.count) { _ in
                        scrollToNextCell(proxy: proxy)
                    }
                }

                HStack {
                    Button("Создать") {
                        addCellWithAnimation()
                    }
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Button("Рестарт") {
                        viewModel.resetCells()
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            .padding()
        }
    }

    private func scrollToNextCell(proxy: ScrollViewProxy) {
        guard let lastIndex = lastVisibleCellIndex else {
            lastVisibleCellIndex = 0
            return
        }
        
        let nextIndex = lastIndex + 1
        if nextIndex < viewModel.cells.count {
            DispatchQueue.main.async {
                withAnimation {
                    proxy.scrollTo(nextIndex, anchor: .bottom)
                }
            }
            lastVisibleCellIndex = nextIndex
        }
    }

    func addCellWithAnimation() {
        let previousCount = viewModel.cells.count
        viewModel.addCell()

        //// Проверка на 3 подряд живые клетки
        if viewModel.cells.suffix(3) == [.alive, .alive, .alive] {
            mergeIndexes = Array((previousCount..<previousCount + 3))
            
            withAnimation(.easeInOut(duration: 0.5)) {
                animateMerging = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    if self.viewModel.cells.count >= 3 {
                        self.viewModel.cells.removeLast(3)
                        self.viewModel.cells.append(.life)
                    }
                    self.animateMerging = false
                }
                self.mergeIndexes = []
            }
        }
    
        /// Проверка на 3 подряд мертвые клетки и удаление ближайшей клетки "Жизнь"
        else if viewModel.cells.suffix(3) == [.dead, .dead, .dead] {
            if let lifeIndex = self.viewModel.cells.lastIndex(of: .life) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.viewModel.cells.remove(at: lifeIndex)
                }
            }
        }
    }
}
#Preview {
    ContentView()
}
