//
//  Theme.swift
//  Todo App
//
//  Created by Cristian Espes on 29/12/2020.
//

import SwiftUI

struct Theme: Identifiable {
    let id: Int
    let themeName: String
    let themeColor: Color
}

let themeData : [Theme] = [
    Theme(id: 0, themeName: "Pink theme", themeColor: .pink),
    Theme(id: 1, themeName: "Blue theme", themeColor: .blue),
    Theme(id: 2, themeName: "Green theme", themeColor: .green)
]

final class ThemeSettings: ObservableObject {
    @Published var themeSettings: Int = UserDefaults.standard.integer(forKey: "Theme") {
        didSet {
            UserDefaults.standard.set(themeSettings, forKey: "Theme")
        }
    }
}
