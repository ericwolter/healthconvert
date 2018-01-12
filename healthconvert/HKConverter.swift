//
//  HealthKitParser.swift
//  healthconvert
//
//  Created by Eric Wolter on 10.01.18.
//  Copyright © 2018 Eric Wolter. All rights reserved.
//

import Foundation

class HKConverter : NSObject, XMLParserDelegate {
  
  var reader : HKRecordReader?
  var writer : HKRecordWriter
  
  init(writer: HKRecordWriter) {
    self.writer = writer
    
    super.init()
  }
  
  var recordCount = 0
  
  func parserDidStartDocument(_ parser: XMLParser) {
    print(#function)
    
    if reader == nil {
      reader = Version7RecordReader()
    }
    reader!.delegate = writer
    
    writer.open()
  }
  
  func parserDidEndDocument(_ parser: XMLParser) {
    print(#function)
    writer.close()
  }
  
  func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
    if(elementName == "Record") {
      reader!.parser!(parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName, attributes: attributeDict)
    }
  }
  
  func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    if(elementName == "Record") {
      recordCount = recordCount + 1
    }
  }
  
  func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
    print("failure error: ", parseError)
  }
}

