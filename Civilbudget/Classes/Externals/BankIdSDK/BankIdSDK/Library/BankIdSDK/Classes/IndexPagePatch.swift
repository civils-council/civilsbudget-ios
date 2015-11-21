//
//  IndexPagePatch.swift
//  BankIdSDK
//
//  Created by Max Odnovolyk on 11/21/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Foundation

// MARK: - Temp BankID mobile layout fix

/**
    Inject custom CSS into BankID index page to add adaptation for tight mobile screens.
    Remove this extension when native mobile version of page will be added.
*/
extension AuthorizationViewController {
    
    /**
        Perform CSS inject into loaded page on `webViewDidFinishLoad:`.
        You can update injected CSS code in `Resources/CSS/bid-index-mobile.css` folder.
        It is handy to use chrome://inspect page with *export modified CSS* function for this purpose.
     */
    func injectCSSPatch() {
        let bundle = NSBundle(forClass: AuthorizationViewController.self)
        var css = try! NSString(contentsOfFile: bundle.pathForResource("bid-index-mobile", ofType: "css")!, encoding: NSUTF8StringEncoding)
        css = css.stringByReplacingOccurrencesOfString("\n", withString: "\\n")
        let js = "var styleNode = document.createElement('style');\n" +
            "styleNode.type = \"text/css\";\n" +
            "var styleText = document.createTextNode('\(css)');\n" +
            "styleNode.appendChild(styleText);\n" +
        "document.getElementsByTagName('head')[0].appendChild(styleNode);\n"
        
        webView.stringByEvaluatingJavaScriptFromString(js)
    }
    
    /// Checks if injection should be performed into the page with specific `URL`
    func shouldPatchPageWithURL(URL: NSURL?) -> Bool {
        if let URLString = URL?.absoluteString
            where URLString.containsString("privatbank") {
                return true
        }
        
        if  let _ = URL?.bid_queries["sidBi"],
            lastPath = URL?.lastPathComponent
            where lastPath == "login" {
                return true
        }
        
        return false
    }
}