//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Romulo Augusto on 21/06/17.
//  Copyright © 2017 Romulo. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        
        super.awakeFromInsert()
        
        self.created = NSDate()
        
        
    }

}
