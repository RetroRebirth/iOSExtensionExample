//
//  ActionViewController.swift
//  MeterFeet
//  source: http://swiftiostutorials.com/tutorial-creating-ios-app-extension-ios-8-perform-custom-actions-safari-content/
//
//  Created by Christopher Williams on 10/20/15.
//  Copyright © 2015 Christopher Williams. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    
    let feetsInMeter = 3.28084
    let metersInFoot = 0.3048
    var jsString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for item: AnyObject in self.extensionContext!.inputItems {
            let inputItem = item as! NSExtensionItem
            
            for provider: AnyObject in inputItem.attachments! {
                
                let itemProvider = provider as! NSItemProvider
                
                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypePropertyList as String) {
                    
                    itemProvider.loadItemForTypeIdentifier(kUTTypePropertyList as String, options: nil, completionHandler: { [unowned self] (result: NSSecureCoding?, error: NSError!) -> Void in
                        
                        if let resultDict = result as? NSDictionary {
                            
                            self.jsString = resultDict[NSExtensionJavaScriptPreprocessingResultsKey]!["content"] as! String
                        }
                        });
                }
            }
        }
    }
    
    func performConversion(regexPattern: String, replacementString: String, multiplier: Double) {
        do {
            let regex = try NSRegularExpression(pattern: regexPattern, options: .CaseInsensitive)
            
            let matches = regex.matchesInString(jsString, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, jsString.characters.count))
            
            for result in matches.reverse() as [NSTextCheckingResult] {
                let match = regex.replacementStringForResult(result, inString: jsString, offset: 0, template: "$0")
                
                let convertsionResult = (match as NSString).doubleValue * multiplier;
                let replacement = String(format: replacementString, arguments: [convertsionResult])
                
                jsString = jsString.stringByReplacingOccurrencesOfString(match, withString: replacement)
            }
        } catch {
            print("conversion failed")
        }
    }
    
    @IBAction func convertMetersToFt() {
        performConversion("(([-+]?[0-9]*\\.?[0-9]+)\\s*(m))", replacementString: "%.2f ft", multiplier: feetsInMeter)
        finalizeReplace()
    }
    
    @IBAction func convertFtToMeters() {
        performConversion("(([-+]?[0-9]*\\.?[0-9]+)\\s*(ft))", replacementString: "%.2f m", multiplier: metersInFoot)
        finalizeReplace()
    }
    
    @IBAction func finalizeReplace() {
        let extensionItem = NSExtensionItem()
        
        let item = NSDictionary(object: NSDictionary(object: jsString, forKey: "content"), forKey: "NSExtensionJavaScriptFinalizeArgumentKey")
        
        let itemProvider = NSItemProvider(item: item, typeIdentifier: kUTTypePropertyList as String)
        extensionItem.attachments = [itemProvider]
        
        self.extensionContext!.completeRequestReturningItems([extensionItem], completionHandler: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
