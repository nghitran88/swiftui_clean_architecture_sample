//
//  CDPhoto+CoreDataProperties.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 14/2/25.
//
//

import Foundation
import CoreData


extension CDPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDPhoto> {
        return NSFetchRequest<CDPhoto>(entityName: "CDPhoto")
    }

    @NSManaged public var albumId: Int64
    @NSManaged public var id: Int64
    @NSManaged public var isFavorite: Bool
    @NSManaged public var thumbnailUrl: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?

}

extension CDPhoto : Identifiable {

}
