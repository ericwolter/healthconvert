//
//  HKRecord.swift
//  healthconvert
//
//  Created by Eric Wolter on 12.01.18.
//  Copyright © 2018 Eric Wolter. All rights reserved.
//

import Foundation

struct HKRecord {
  var type: String
  var dict: Dictionary<String, String>
  
  var description: String {
    return "\(type) with \(dict.count) attribute(s)."
  }
}
