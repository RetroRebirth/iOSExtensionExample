//
//  ShareViewController.swift
//  URLShareExtension
//
//  Created by Christopher Williams on 10/22/15.
//  Copyright © 2015 Christopher Williams. All rights reserved.
//

import Foundation
import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
    
    var url = ""
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        let inputItem = self.extensionContext!.inputItems[0] as! NSExtensionItem
        let itemProvider = inputItem.attachments![0] as! NSItemProvider
        
        // Are we sharing something with a URL attached to it?
        if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
            // If so, start a worker thread to grab the URL
            itemProvider.loadItemForTypeIdentifier(kUTTypeURL as String, options: nil, completionHandler: { (item, error) in
                // Parse the URL as a string
                self.url = (item as! NSURL).absoluteString
                
                // Save the URL to be rendered in app
                let sharedDefaults = NSUserDefaults(suiteName: "group.me.christopherwilliams.iOSExtensionExample")
                sharedDefaults?.setObject(self.url, forKey: "urlKey")
                sharedDefaults?.synchronize()
                
                self.extensionContext?.completeRequestReturningItems([], completionHandler: nil)
            })
        }
    }

    override func configurationItems() -> [AnyObject]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.

        // TODO alter share composition UI to include title, description, and pricing
//        let test:SLComposeSheetConfigurationItem = SLComposeSheetConfigurationItem()
//        test.title = "test"
//        test.value = "Hello world!"
//        
//        return [test]
        
        return []
    }

}
