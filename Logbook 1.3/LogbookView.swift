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
        entity: Flight.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Flight.date, ascending: true)]
    ) private var flights: FetchedResults<Flight>

    @State private var showingAddPairingView = false

    var body: some View {
        NavigationView {
            List {
                ForEach(flights, id: \.id) { flight in
                    FlightRowView(flight: flight)
                }
                .onDelete(perform: deleteFlights)
            }
            .navigationTitle("Logbook")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    EditButton()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddPairingView.toggle()
                    }) {
                        Label("Add Flight", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddPairingView) {
                AddPairingView(showingAddPairingView: $showingAddPairingView)
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }

    private func deleteFlights(offsets: IndexSet) {
        withAnimation {
            offsets.map { flights[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct FlightRowView: View {
    var flight: Flight

    var body: some View {
        VStack(alignment: .leading) {
            Text(flight.flightNumber ?? "Unknown Flight")
                .font(.headline)
            Text(flight.date ?? Date(), style: .date)
                .font(.subheadline)
            Text("Aircraft: \(flight.aircraftID ?? "N/A")")
                .font(.subheadline)
        }
    }
}
