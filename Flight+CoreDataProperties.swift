//
//  Flight+CoreDataProperties.swift
//  Logbook 1.3
//
//  Created by Tomasz Zuczek on 13/07/2024.
//
//

import Foundation
import CoreData


extension Flight {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Flight> {
        return NSFetchRequest<Flight>(entityName: "Flight")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var aircraftID: String?
    @NSManaged public var picName: String?
    @NSManaged public var sicName: String?
    @NSManaged public var flightNumber: String?
    @NSManaged public var pairing: Pairing?
    
    override public func awakeFromInsert() {
            super.awakeFromInsert()
            setPrimitiveValue(UUID(), forKey: "id")
        }

}

extension Flight : Identifiable {

}
