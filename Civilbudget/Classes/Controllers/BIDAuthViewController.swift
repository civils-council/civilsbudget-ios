//
//  BIDAuthViewController.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 10/7/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit
import Alamofire

class BIDAuthViewController: UIViewController {
    
    /**
        You may change this static property to specify custom *nib* name without subclassing `BIDAuthViewController` class
    */
    static var defaultAuthNibName: String? = "BIDAuthViewController"
    
    /**
        You may change this static property to specify custom *nib* bundle without subclassing `BIDAuthViewController` class
    */
    static var defaultAuthNibBundle: NSBundle? = nil
    
    private var completionHandler: (BIDService.AuthorizationResult -> Void)?
    private var getOnlyAuthCode = false
    private var patchIndexPage = true
    
    var requestCounter: Int = 0 {
        didSet {
            if requestCounter == 0 {
                activityIndicatorContainer.hidden = true
                activityIndicator.stopAnimating()
            } else {
                activityIndicatorContainer.hidden = false
                activityIndicator.startAnimating()
            }
        }
    }
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet var authNavigationItem: UINavigationItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicatorContainer: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    /**
        Subclasses may override this type method to change name of default *nib* name
    */
    class func authNibName() -> String? {
        return self.defaultAuthNibName
    }
    
    /**
        Subclasses may override this type method to load *nib* from another bundle
    */
    class func authNibBundle() -> NSBundle? {
        return self.defaultAuthNibBundle
    }
    
    init(getOnlyAuthCode:Bool = false, patchIndexPage: Bool = true, completionHandler:BIDService.AuthorizationResult -> Void) {
        super.init(nibName: self.dynamicType.authNibName(), bundle: self.dynamicType.authNibBundle())
        
        self.getOnlyAuthCode = getOnlyAuthCode
        self.completionHandler = completionHandler
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItems = authNavigationItem.leftBarButtonItems
        navigationItem.rightBarButtonItems = authNavigationItem.rightBarButtonItems
        
        updateControls()
        
        webView.loadRequest(BIDService.Router.Authorize.URLRequest)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        moveUIFromUnderNavigationBar()
    }
    
    @IBAction func closeButtonTapped(sender: UIBarButtonItem) {
        let canceledError = BIDService.errorWithCode(BIDCanceledCode, description: NSLocalizedString("Authorization was canceled by User", comment: "Canceled by user authorization error description"))
        dismissWithResult(BIDService.AuthorizationResult.Failure(canceledError))
    }
    
    @IBAction func backButtonTapped(sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    @IBAction func forwardButtonTapped(sender: UIBarButtonItem) {
        webView.goForward()
    }
    
    func updateControls() {
        backButton.enabled = webView.canGoBack
        forwardButton.enabled = webView.canGoForward
    }
    
    func disableControls() {
        backButton.enabled = false
        forwardButton.enabled = false
    }
    
    func moveUIFromUnderNavigationBar() {
        
    }
    
    func dismissWithResult(result: BIDService.AuthorizationResult) {
        guard let completionHandler = completionHandler else {
            return
        }
        
        completionHandler(result)
        self.completionHandler = nil
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension BIDAuthViewController: UIWebViewDelegate {
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        log.info(request.URL?.absoluteString)
        
        if let url = request.URL,
            code = url.queries["code"]
            where url.absoluteString.hasPrefix(BIDService.redirectURI) {
                
                if getOnlyAuthCode {
                    let auth = BIDService.Authorization(authCode: code)
                    dismissWithResult(BIDService.AuthorizationResult.Success(auth))
                } else {
                    requestCounter++
                    webView.loadRequest(NSURLRequest(URL: NSURL(string:"about:blank")!))
                    disableControls()
                    
                    Alamofire.request(BIDService.Router.GetAccessToken(authCode: code))
                        .responseObject { [weak self] (response: BIDService.AuthorizationResponse) in
                            self?.dismissWithResult(response.result)
                    }
                }
                
                return false
        }
        
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        requestCounter++
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let currentURL = webView.request?.URL
        if patchIndexPage && shouldPatchPageWithURL(currentURL) {
            injectCSSPatch()
        }
        
        if let message = currentURL?.queries["message"] {
            dismissWithResult(BIDService.AuthorizationResult.Failure(BIDService.errorWithCode(BIDTimeoutCode, description: message)))
        }
        
        requestCounter--
        
        updateControls()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        let WebKitErrorDomain = "WebKitErrorDomain"
        let WebKitErrorFrameLoadInterrupted = 102
        
        requestCounter--
        
        guard let domain = error?.domain,
            code = error?.code
            where domain != WebKitErrorDomain && code != WebKitErrorFrameLoadInterrupted
            else {
                return
        }
        
        dismissWithResult(BIDService.AuthorizationResult.Failure(error!))
    }
}

/**
    Inject custom CSS into BankID index page to add adaptation for tight mobile screens.
    Remove this extension when native mobile version of page will be added.
*/
extension BIDAuthViewController {
    
    /**
        Perform CSS inject into loaded page on `webViewDidFinishLoad:`.
        You can update injected CSS code in `Resources/CSS/bid-index-mobile.css` folder.
        It is handy to use chrome://inspect page with *export modified CSS* function for this purpose.
    */
    func injectCSSPatch() {
        let bundle = NSBundle.mainBundle()
        var css = try! NSString(contentsOfFile: bundle.pathForResource("bid-index-mobile", ofType: "css")!, encoding: NSUTF8StringEncoding)
        css = css.stringByReplacingOccurrencesOfString("\n", withString: "\\n")
        let js = "var styleNode = document.createElement('style');\n" +
            "styleNode.type = \"text/css\";\n" +
            "var styleText = document.createTextNode('\(css)');\n" +
            "styleNode.appendChild(styleText);\n" +
        "document.getElementsByTagName('head')[0].appendChild(styleNode);\n"
        
        webView.stringByEvaluatingJavaScriptFromString(js)
    }
    
    /**
        Check if injection should be performed into the page with specific `URL`
    */
    func shouldPatchPageWithURL(URL: NSURL?) -> Bool {
        if let URLString = URL?.absoluteString
            where URLString.containsString("privatbank") {
                return true
        }
        
        if  let _ = URL?.queries["sidBi"],
            lastPath = URL?.lastPathComponent
            where lastPath == "login" {
                return true
        }
        
        return false
    }
}