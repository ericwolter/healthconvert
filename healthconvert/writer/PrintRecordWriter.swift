//
//  PrintRecordWriter.swift
//  healthconvert
//
//  Created by Eric Wolter on 12.01.18.
//  Copyright © 2018 Eric Wolter. All rights reserved.
//

import Foundation

class PrintRecordWriter: HKRecordWriter {
  
  var separator = ","
  let headers = ["type","unit","value","sourceName","sourceVersion","device","creationDate","startDate","endDate"]
  
  func open() {}
  func close() {}

  func onComplete(record: HKRecord) {
    var values: [String] = []
    for header in headers {
      values.append("\"\(record.dict[header] ?? "")\"")
    }
    let dataRow = values.joined(separator: separator)
    print(dataRow)
  }
}
