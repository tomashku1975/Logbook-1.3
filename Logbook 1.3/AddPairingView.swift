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

    @State private var date: Date = Date()
    @State private var flightNumbers: String = ""
    @State private var aircraftID: String = ""

    private var pairings: FetchedResults<Pairing>
    
    init(pairings: FetchedResults<Pairing>) {
            self.pairings = pairings
        }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Pairing Details")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    TextField("Flight Numbers (separated by space)", text: $flightNumbers)
                }
                Section(header: Text("Flight Details")) {
                    ForEach(pairings, id: \.self) { pairing in
                        Text(pairing.flightNumbers ?? "")
                    }
                }
                Section {
                    Button(action: addPairing) {
                        Text("Add Pairing")
                    }
                }
            }
            .navigationTitle("Add Pairing")
        }
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
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
