//
//  CityWeather+CoreDataProperties.swift
//  
//
//  Created by Sopo on 2/2/21.
//
//

import Foundation
import CoreData


extension CityWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityWeather> {
        return NSFetchRequest<CityWeather>(entityName: "CityWeather")
    }

    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var icon: String?
    @NSManaged public var message: String?
    @NSManaged public var temperature: Float
    @NSManaged public var cloudiness: Float
    @NSManaged public var humidity: Float
    @NSManaged public var windDirection: Float
    @NSManaged public var windSpeed: Float

}
