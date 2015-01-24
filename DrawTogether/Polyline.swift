//
//  Polyline.swift
//  DrawTogether
//
//  Created by James Nocentini on 23/01/2015.
//  Copyright (c) 2015 James Nocentini. All rights reserved.
//

import UIKit

class Polyline: CBLModel {
   
    @NSManaged var points: [[String : CGFloat]]
    
    init() {
        super.init(document: kDatabase.createDocument())
        
        setValue("polyline", ofProperty: "type")
        self.points = []
    }
    
    override init!(document: CBLDoc!) {
        super.init(document: document)
    }
    
}
