//
//  ThemeSettings.swift
//  Todo App
//
//  Created by Cristian Espes on 29/12/2020.
//

import SwiftUI

final class ThemeSettings: ObservableObject {
    @Published var themeSettings: Int = UserDefaults.standard.integer(forKey: "Theme") {
        didSet {
            UserDefaults.standard.set(themeSettings, forKey: "Theme")
        }
    }
}
