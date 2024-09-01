//
//  Cell.swift
//  CellGame
//
//  Created by Артем Гаршин on 31.08.2024.
//

import SwiftUI

enum Cell: String, Identifiable, Equatable, Codable {
    case dead = "Мёртвая"
    case alive = "Живая"
    case life = "Жизнь"
    
    var id: UUID {
        return UUID()
    }
}
