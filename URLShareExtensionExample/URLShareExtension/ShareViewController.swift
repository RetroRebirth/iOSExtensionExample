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

class ShareViewController: SLComposeServiceViewController, NSURLSessionDelegate {
    
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
                
                // Run NSURLSession to send info to Treasure backend
                // http://jamesonquave.com/blog/making-a-post-request-in-swift/#jumpSwift
                let params = ["auth_token":"X9DSUoksFskqPTm14BbXoV1Q", "url":self.url] as Dictionary<String, String>
                
                let request = NSMutableURLRequest(URL: NSURL(string: "http://shop.treasureapp.com/api/v1/products")!)
                request.HTTPMethod = "POST"
                do {
                    request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: [])
                } catch {
                    print("error in JSON serialization")
                }
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                let session = NSURLSession.sharedSession()
                
                let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
                    print("Response: \(response)")
                    
                    // TODO process response
                    
                    self.extensionContext?.completeRequestReturningItems([], completionHandler: nil)
                })
                task.resume()
            })
        }
    }

    override func configurationItems() -> [AnyObject]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.

        // TODO alter share composition UI to include title, description, and pricing
//        let test:SLComposeSheetConfigurationItem = SLComposeSheetConfigurationItem()
//        test.title = "test"
//        test.value = "Hello world!"
//        test.tapHandler = { () in
//            let vc = ItemViewController() // TODO not working
//            self.pushConfigurationViewController(vc)
//        }
//        
//        return [test]
        
        return []
    }
    
    func URLSession(session: NSURLSession, didBecomeInvalidWithError error: NSError?) {
        print("error :(")
    }
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        print("finished!")
    }
    
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        print("received authorization challenge")
    }

}
