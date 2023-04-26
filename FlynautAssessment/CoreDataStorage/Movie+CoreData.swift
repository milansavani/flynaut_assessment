//
//  Movie+CoreData.swift
//  FlynautAssessment
//
//  Created by iMac on 25/04/23.
//

import Foundation
import CoreData

@objc(Movie)
public class Movie: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var isfavourite: Bool

}
