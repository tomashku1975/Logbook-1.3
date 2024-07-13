//
//  LogbookView.swift
//  Logbook 1.3
//
//  Created by Tomasz Zuczek on 13/07/2024.
//

import SwiftUI
import CoreData

struct LogbookView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Pairing.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Pairing.date, ascending: true)]
    ) private var pairings: FetchedResults<Pairing>

    @State private var showingAddPairingView = false

    var body: some View {
        NavigationView {
            List {
                ForEach(pairings, id: \.id) { pairing in
                    Text(pairing.flightNumbers ?? "")
                }
                .onDelete(perform: deletePairings)
            }
            .navigationTitle("Logbook")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddPairingView.toggle()
                    }) {
                        Label("Add Pairing", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddPairingView) {
                AddPairingView(pairings: pairings)
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }

    private func deletePairings(offsets: IndexSet) {
        withAnimation {
            offsets.map { pairings[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}





private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()
