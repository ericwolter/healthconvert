//
//  CSVRecordWriter.swift
//  healthconvert
//
//  Created by Eric Wolter on 12.01.18.
//  Copyright © 2018 Eric Wolter. All rights reserved.
//

import Foundation

class CSVRecordWriter: HKRecordWriter {
  
  var outputStreams = Dictionary<String, OutputStream>()
  
  var separator = ","
  var newline = "\r\n"
  let headers = ["unit","value","sourceName","sourceVersion","device","creationDate","startDate","endDate"]
  
  func open() {}
  
  func onComplete(record: HKRecord) {
    var outputStream = outputStreams[record.type]
    if outputStream == nil {
      let tempPath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(record.type).appendingPathExtension("csv")
      FileManager.default.createFile(atPath: tempPath.path, contents: nil, attributes: nil)
      outputStream = OutputStream(toFileAtPath: tempPath.path, append: true)
      
      let headerRow = headers.joined(separator: separator) + newline
      let data = headerRow.data(using: String.Encoding.utf8)!
      var buffer = [UInt8](data)
      outputStream?.open()
      outputStream?.write(&buffer, maxLength: data.count)
      
      outputStreams[record.type] = outputStream
    }
    
    var values: [String] = []
    for header in headers {
      values.append("\"\(record.dict[header] ?? "")\"")
    }
    let dataRow = values.joined(separator: separator) + newline
    var data = dataRow.data(using: String.Encoding.utf8)!
    var buffer = [UInt8](data)
    outputStream?.write(&buffer, maxLength: data.count)
  }
  
  func close() {
    for stream in outputStreams.values {
      stream.close()
    }
  }
}
