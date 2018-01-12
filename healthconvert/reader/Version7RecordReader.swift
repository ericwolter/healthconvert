//
//  Version7RecordReader.swift
//  healthconvert
//
//  Created by Eric Wolter on 12.01.18.
//  Copyright © 2018 Eric Wolter. All rights reserved.
//

import Foundation

class Version7RecordReader: NSObject, HKRecordReader {
  var delegate: HKRecordReaderDelegate?
  
  func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
    
    if elementName != "Record" {
      return;
    }
    
    guard let type = attributeDict["type"] else {
      return;
    }
    
    let record = HKRecord(type: type, dict: attributeDict)
    delegate?.onComplete(record: record)
  }
}
