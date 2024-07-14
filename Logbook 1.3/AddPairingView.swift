//
//  AddPairingView.swift
//  Logbook 1.3
//
//  Created by Tomasz Zuczek on 13/07/2024.
//

import SwiftUI
import CoreData

struct AddPairingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var showingAddPairingView: Bool

    @State private var date: Date = Date()
    @State private var flightNumbers: String = ""
    @State private var aircraftID: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Pairing Details")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    TextField("Flight Numbers (separated by space)", text: $flightNumbers)
                        .onChange(of: flightNumbers) { _ in
                            self.updateFlights()
                        }
                }
                
                Section(header: Text("Flight Details")) {
                    ForEach(flightNumbers.split(separator: " "), id: \.self) { flightNumber in
                        Text("Flight: \(flightNumber)")
                    }
                }

                Section {
                    Button(action: {
                        addPairing()
                    }) {
                        Text("Add Pairing")
                    }
                }
            }
            .navigationTitle("Add Pairing")
        }
    }

    private func updateFlights() {
        // Additional logic to dynamically update flight details if needed.
    }

    private func addPairing() {
        let newPairing = Pairing(context: viewContext)
        newPairing.date = date
        newPairing.flightNumbers = flightNumbers

        let flightNumberArray = flightNumbers.split(separator: " ").map { String($0) }

        for flightNumber in flightNumberArray {
            let newFlight = Flight(context: viewContext)
            newFlight.date = date
            newFlight.aircraftID = aircraftID
            newFlight.flightNumber = flightNumber
            newFlight.pairing = newPairing
        }

        do {
            try viewContext.save()
            // Clear the flight numbers and close the sheet
            flightNumbers = ""
            showingAddPairingView = false
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
