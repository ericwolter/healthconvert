//
//  ZipFileStream.swift
//  input
//
//  Created by Eric Wolter on 10.01.18.
//  Copyright © 2018 Eric Wolter. All rights reserved.
//

import Foundation
import Compression

enum StreamError: Error {
  case unseekableFile
}

public final class ZipInputStream : InputStream {
  var archive: UnsafeMutablePointer<FILE>
  var entry: Entry
  
  let operation = COMPRESSION_STREAM_DECODE
  
  var position: Int
  var fileSize: Int {
    get { return Int(entry.centralDirectoryStructure.compressedSize) }
  }
  
  var streamPtr: UnsafeMutablePointer<compression_stream>
  var status: compression_status
  
  init(archive: UnsafeMutablePointer<FILE>, entry: Entry) {
    self.archive = archive
    self.entry = entry
    self.position = 0;
    
    self.streamPtr = UnsafeMutablePointer<compression_stream>.allocate(capacity: 1)
    self.status = COMPRESSION_STATUS_ERROR;
    super.init(data: Data())
  }
  
  convenience override init(data: Data) {
    self.init()
  }
  
  convenience init() {
    self.init()
  }
  
  override public func open() {
    status = compression_stream_init(&streamPtr.pointee, operation, COMPRESSION_ZLIB)

  }
  
  override public func close() {
    compression_stream_destroy(&streamPtr.pointee)
    free(streamPtr)
  }
  
  static func readChunk(from file: UnsafeMutablePointer<FILE>, size: Int) throws -> Data {
    let bytes = UnsafeMutableRawPointer.allocate(bytes: size, alignedTo: 1)
    let bytesRead = fread(bytes, 1, size, file)
    let error = ferror(file)
    if error > 0 {
      throw Data.DataError.unreadableFile
    }
    return Data(bytesNoCopy: bytes, count: bytesRead, deallocator: Data.Deallocator.free)
  }
  
  func adjustChunk(file: UnsafeMutablePointer<FILE>, offset: Int) throws -> Int {
    let result = fseek(file, offset, SEEK_CUR)
    let error = ferror(file)
    if error > 0 {
      throw StreamError.unseekableFile
    }
    return Int(result)
  }
  
  override public func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
    var stream = streamPtr.pointee
    stream.src_size = 0
    stream.dst_ptr = buffer
    stream.dst_size = len
    var flags = Int32(0)
    
    // fill source buffer
    let readSize = (fileSize - position) >= len ? len : (fileSize - position)
    guard let chunk = try? Data.readChunk(from: archive, size: readSize) else {
      print("Error reading chunk", position, readSize)
      return -1;
    }
    chunk.withUnsafeBytes { stream.src_ptr = $0 }
    stream.src_size = chunk.count
    
    // decompress & return data
    if position >= fileSize {
      flags = Int32(COMPRESSION_STREAM_FINALIZE.rawValue)
    }
    
    status = compression_stream_process(&stream, flags)
    
    let readCount = chunk.count - stream.src_size
    position = position + readCount
    var writeCount = len - stream.dst_size
    guard (try? adjustChunk(file: archive, offset: -stream.src_size)) != nil else {
      print("Error adjusting chunk", position)
      return -1;
    }
    
    switch status {
    case COMPRESSION_STATUS_OK: break
    case COMPRESSION_STATUS_END:
      if stream.dst_ptr > buffer {
        writeCount = stream.dst_ptr - buffer;
      }
    case COMPRESSION_STATUS_ERROR: fallthrough
    default:
      print("Error during uncompress", position)
      return -1;
    }
    
    return writeCount;
  }
  
  override public func getBuffer(_ buffer: UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>, length len: UnsafeMutablePointer<Int>) -> Bool {
    return false;
  }
  
  override public var hasBytesAvailable: Bool { get { return true; } }
  
}
