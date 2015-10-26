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

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
//        let sharedDefaults = NSUserDefaults(suiteName: "group.me.christopherwilliams.iOSExtensionExample")
        
        let inputItem = self.extensionContext!.inputItems[0] as! NSExtensionItem
        let itemProvider = inputItem.attachments![0] as! NSItemProvider
        
        if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
            itemProvider.loadItemForTypeIdentifier(kUTTypeURL as String, options: nil, completionHandler: { (item, error) in
                print(item!)
//                sharedDefaults?.setObject(item, forKey: "stringKey")
//                
//                sharedDefaults?.synchronize()
//                
//                self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
            })
        }
    }

    override func configurationItems() -> [AnyObject]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
