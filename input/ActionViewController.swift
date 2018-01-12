//
//  ActionViewController.swift
//  input
//
//  Created by Eric Wolter on 10.01.18.
//  Copyright © 2018 Eric Wolter. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController, XMLParserDelegate {

  @IBOutlet weak var imageView: UIImageView!

  override func viewDidLoad() {
    super.viewDidLoad()

    for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
        for provider in item.attachments! as! [NSItemProvider] {
            if provider.hasItemConformingToTypeIdentifier(kUTTypeFileURL as String) {
                provider.loadItem(forTypeIdentifier: kUTTypeFileURL as String, options: nil, completionHandler: { (fileURL, error) in
                    OperationQueue.main.addOperation {
                      guard let fileURL = fileURL as? URL else {
                        // TODO: error handling
                        return
                      }
                      guard let archive = Archive(url: fileURL, accessMode: .read) else {
                        // TODO: error handling
                        return
                      }
                      guard let export = archive["apple_health_export/Export.xml"] else {
                        // TODO: error handling
                        return
                      }
                      do {
                        let stream = try archive.extractFile(export)
                        let xml = XMLParser(stream: stream)
                        xml.delegate = self;
                        xml.parse()
                      } catch {
                        // TODO: error handling
                        return
                      }
                    }
                })
            }
        }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func done() {
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
  }

}
