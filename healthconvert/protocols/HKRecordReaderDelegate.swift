//
//  HKRecordReaderDelegate.swift
//  healthconvert
//
//  Created by Eric Wolter on 12.01.18.
//  Copyright © 2018 Eric Wolter. All rights reserved.
//

import Foundation

protocol HKRecordReaderDelegate {
  func onComplete(record: HKRecord)
}
