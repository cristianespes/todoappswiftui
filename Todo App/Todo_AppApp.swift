//
//  Todo_AppApp.swift
//  Todo App
//
//  Created by Cristian Espes on 27/12/2020.
//

import SwiftUI
import CoreData

@main
struct Todo_AppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var iconSettings = IconNames()
    @StateObject var theme = ThemeSettings()
    
    private let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(iconSettings)
                .environmentObject(theme)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
}

final class IconNames: ObservableObject {
    
    @Published var currentIndex = 0
    
    var iconNames: [String?] = [nil]
    
    init() {
        getAlternativeIconNames()
        
        if let currentIcon = UIApplication.shared.alternateIconName {
            currentIndex = iconNames.firstIndex(of: currentIcon) ?? 0
        }
    }
    
    func getAlternativeIconNames() {
        if let icons = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
           let alternateIcons = icons["CFBundleAlternateIcons"] as? [String: Any] {
            for (_, value) in alternateIcons {
                guard let iconList = value as? Dictionary<String, Any> else { return }
                guard let iconFiles = iconList["CFBundleIconFiles"] as? [String] else { return }
                guard let icon = iconFiles.first else { return }
                
                iconNames.append(icon)
            }
        }
    }
}
