//
//  Pairing+CoreDataProperties.swift
//  Logbook 1.3
//
//  Created by Tomasz Zuczek on 13/07/2024.
//
//

import Foundation
import CoreData


extension Pairing {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pairing> {
        return NSFetchRequest<Pairing>(entityName: "Pairing")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var flightNumbers: String?
    @NSManaged public var flights: NSSet? 
    
    override public func awakeFromInsert() {
            super.awakeFromInsert()
            setPrimitiveValue(UUID(), forKey: "id")
        }

}

extension Pairing {
    var flightsArray: [Flight] {
        let set = flights as? Set<Flight> ?? []
        return set.sorted {
            $0.flightNumber ?? "" < $1.flightNumber ?? ""
        }
    }
}
extension Pairing : Identifiable {

}
