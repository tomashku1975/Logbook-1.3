//
//  Logbook_1_3App.swift
//  Logbook 1.3
//
//  Created by Tomasz Zuczek on 13/07/2024.
//

import SwiftUI

@main
struct Logbook_1_3App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
