//
//  CellsViewModel.swift
//  CellGame
//
//  Created by Артем Гаршин on 31.08.2024.
//

import SwiftUI

class CellsViewModel: ObservableObject {
    @Published var cells: [Cell] = [] {
        didSet {
            saveCellsToUserDefaults()
        }
    }

    init() {
        loadCellsFromUserDefaults()
    }

    func addCell() {
        let previousCount = cells.count
        let newCell: Cell = Bool.random() ? .alive : .dead
        cells.append(newCell)
        checkForLifeOrDeath(previousCount: previousCount)
    }
    
    private func checkForLifeOrDeath(previousCount: Int) {
        /// Проверяем только на последовательность трех живых клеток
        if cells.suffix(3) == [.alive, .alive, .alive] {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
                if self.cells.count >= 3 {
                    /// Удаляем последние три живые клетки
                    self.cells.removeLast(3)
                    /// Добавляем одну клетку "Жизнь"
                    self.cells.append(.life)
                }
            }
        }
        /// Удаляем ближайшую клетку "Жизнь" при трех подряд мертвых клетках
        else if cells.suffix(3) == [.dead, .dead, .dead] {
            if let lifeIndex = cells.lastIndex(of: .life) {
                DispatchQueue.main.async {
                    self.cells.remove(at: lifeIndex)
                }
            }
        }
    }

    private func saveCellsToUserDefaults() {
        let encodedData = try? JSONEncoder().encode(cells)
        UserDefaults.standard.set(encodedData, forKey: "cells")
    }

    private func loadCellsFromUserDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: "cells"),
           let decodedCells = try? JSONDecoder().decode([Cell].self, from: savedData) {
            self.cells = decodedCells
        }
    }
    
    func resetCells() {
        self.cells = []
    }
}
