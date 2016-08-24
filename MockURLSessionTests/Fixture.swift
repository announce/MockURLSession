//
//  Fixture.swift
//  MockURLSession
//
//  Created by YAMAMOTOKenta on 8/24/16.
//  Copyright © 2016 ymkjp. All rights reserved.
//

import Foundation

class Fixture {
    static func read(name: String, ofType: String = "json") -> NSData {
        let path = NSBundle(forClass:self).pathForResource(name, ofType: ofType)
        return try! NSData(contentsOfURL: NSURL(fileURLWithPath: path!), options: NSDataReadingOptions.DataReadingMappedIfSafe)
    }
}
