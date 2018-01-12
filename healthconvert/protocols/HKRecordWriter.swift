//
//  HKRecordWriter.swift
//  healthconvert
//
//  Created by Eric Wolter on 12.01.18.
//  Copyright © 2018 Eric Wolter. All rights reserved.
//

import Foundation

protocol HKRecordWriter: HKRecordReaderDelegate {
  func open()
  func close()
}