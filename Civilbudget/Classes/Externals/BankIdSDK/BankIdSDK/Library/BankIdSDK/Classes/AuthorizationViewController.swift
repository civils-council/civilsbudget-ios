//
//  AuthorizationViewController.swift
//  BankIdSDK
//
//  Created by Max Odnovolyk on 11/21/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit
import Alamofire

public class AuthorizationViewController: UIViewController {
    
    /// You may change this static property to specify custom *nib* name without subclassing `BIDAuthViewController` class
    static var defaultAuthNibName: String? = "AuthorizationViewController"
    
    
    /// You may change this static property to specify custom *nib* bundle without subclassing `BIDAuthViewController` class
    static var defaultAuthNibBundle: NSBundle? = NSBundle(forClass: AuthorizationViewController.self)
    
    private var completionHandler: (AuthorizationResult -> Void)?
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
    
    @IBOutlet var authNavigationItem: UINavigationItem!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicatorContainer: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    /// Subclasses may override this type method to change name of default *nib* name
    class func authNibName() -> String? {
        return self.defaultAuthNibName
    }
    
    /// Subclasses may override this type method to load *nib* from another bundle
    class func authNibBundle() -> NSBundle? {
        return self.defaultAuthNibBundle
    }
    
    public init(getOnlyAuthCode:Bool = false, patchIndexPage: Bool = true, completionHandler:AuthorizationResult -> Void) {
        super.init(nibName: self.dynamicType.authNibName(), bundle: self.dynamicType.authNibBundle())
        
        self.getOnlyAuthCode = getOnlyAuthCode
        self.completionHandler = completionHandler
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItems = authNavigationItem.leftBarButtonItems
        navigationItem.rightBarButtonItems = authNavigationItem.rightBarButtonItems
        
        updateControls()
        
        webView.loadRequest(Service.Router.Authorize.URLRequest)
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        moveUIFromUnderNavigationBar()
    }
    
    @IBAction func closeButtonTapped(sender: UIBarButtonItem) {
        dismissWithResult(AuthorizationResult.Failure(Error(code: .Canceled)))
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
    
    func dismissWithResult(result: AuthorizationResult) {
        guard let completionHandler = completionHandler else {
            return
        }
        
        completionHandler(result)
        self.completionHandler = nil
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - UIWebView delegated methods

extension AuthorizationViewController: UIWebViewDelegate {
    public func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.URL,
            code = url.bid_queries["code"]
            where url.absoluteString.hasPrefix(Service.configuration.redirectURI) {
                
                if getOnlyAuthCode {
                    let auth = Authorization(authCode: code)
                    dismissWithResult(AuthorizationResult.Success(auth))
                } else {
                    requestCounter++
                    webView.loadRequest(NSURLRequest(URL: NSURL(string:"about:blank")!))
                    disableControls()
                    
                    Alamofire.request(Service.Router.GetAccessToken(authCode: code))
                        .responseBankIdObject { [weak self] (response: Response<Authorization, NSError>) in
                            self?.dismissWithResult(response.result)
                    }
                }
                
                return false
        }
        
        return true
    }
    
    public func webViewDidStartLoad(webView: UIWebView) {
        requestCounter++
    }
    
    public func webViewDidFinishLoad(webView: UIWebView) {
        let currentURL = webView.request?.URL
        if patchIndexPage && shouldPatchPageWithURL(currentURL) {
            injectCSSPatch()
        }
        
        if let message = currentURL?.bid_queries["message"] {
            dismissWithResult(AuthorizationResult.Failure(Error(code: .Timeout, description: message)))
        }
        
        requestCounter--
        
        updateControls()
    }
    
    public func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
        /// `UIWebView` throws this error if `shouldStartLoadWithRequest` returs `false`
        let WebKitErrorDomain = "WebKitErrorDomain"
        let WebKitErrorFrameLoadInterrupted = 102
        
        requestCounter--
        
        guard let domain = error?.domain,
            code = error?.code
            where domain != WebKitErrorDomain && code != WebKitErrorFrameLoadInterrupted
            else {
                return
        }
        
        dismissWithResult(AuthorizationResult.Failure(error!))
    }
}