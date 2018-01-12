//
//  healthconvertTests.swift
//  healthconvertTests
//
//  Created by Eric Wolter on 10.01.18.
//  Copyright © 2018 Eric Wolter. All rights reserved.
//

import XCTest
@testable import healthconvert

class healthconvertTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
  
//  func testExample1() {
//    let urlpath = Bundle.main.path(forResource: "Export", ofType: "zip")
//    let fileURL = NSURL.fileURL(withPath: urlpath!)
//    guard let archive = Archive(url: fileURL, accessMode: .read) else {
//      // TODO: error handling
//      return
//    }
//    guard let export = archive["apple_health_export/Export.xml"] else {
//      // TODO: error handling
//      return
//    }
//    do {
//      var allData = NSMutableData()
//      try archive.extract(export, consumer: { (data) in
//        allData.append(data)
//      })
//      let data = allData as Data
//      print(data.count)
//      let xml = XMLParser(data: allData as Data)
//      let parser = HealthKitParser()
//      xml.delegate = parser
//      xml.parse()
//    } catch {
//
//    }
//  }
  
    func testExample2() {
      let urlpath = Bundle.main.path(forResource: "Export", ofType: "zip")
      let fileURL = NSURL.fileURL(withPath: urlpath!)
      guard let archive = Archive(url: fileURL, accessMode: .read) else {
        // TODO: error handling
        return
      }
      guard let export = archive["apple_health_export/Export.xml"] else {
        // TODO: error handling
        return
      }
      do {
        let writer = PrintRecordWriter()
        let converter = HKConverter(writer: writer)
        
        let stream = try archive.extractFile(export)
        let xml = XMLParser(stream: stream)
        xml.delegate = converter;
        xml.parse()
      } catch {
        // TODO: error handling
        return
      }

        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
  
  
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
  
}
