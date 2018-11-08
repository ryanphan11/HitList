//
//  Person.swift
//  HitList
//
//  Created by Ryan Phan on 11/8/18.
//  Copyright © 2018 Ryan Phan. All rights reserved.
//

import UIKit
import CoreData

class Person: NSManagedObject {
    convenience init(context: NSManagedObjectContext, name: String) {
        self.init(context: context)
        self.name = name
    }
}
