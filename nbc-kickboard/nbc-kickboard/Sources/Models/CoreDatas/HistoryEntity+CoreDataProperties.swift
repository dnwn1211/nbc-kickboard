//
//  HistoryEntity+CoreDataProperties.swift
//  nbc-kickboard
//
//  Created by 권승용 on 12/16/24.
//
//

import Foundation
import CoreData


extension HistoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoryEntity> {
        return NSFetchRequest<HistoryEntity>(entityName: "HistoryEntity")
    }

    @NSManaged public var cost: Int16
    @NSManaged public var rentDate: Date?
    @NSManaged public var totalRentTime: Int16
    @NSManaged public var kickboard: KickboardEntity?
    @NSManaged public var user: UserEntity?

    enum Key {
        static let cost = "cost"
        static let rentDate = "rentDate"
        static let totalRentTime = "totalRentTime"
        static let kickboard = "kickboard"
        static let user = "user"
    }
}

extension HistoryEntity : Identifiable {

}
