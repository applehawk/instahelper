//
//  AuthorizeViewController.swift
//  InstaHelper
//
//  Created by Hawk on 20/01/16.
//  Copyright © 2016 Hawk. All rights reserved.
//

import UIKit

class AuthorizeViewController: UIViewController, UIWebViewDelegate, ChangeTitleAuthButtonDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var buttonAuthorize: UIButton!
    
    var engine : InstagramEngine?
    var token : String?
    
    func changeTitle(title: String) {
        buttonAuthorize.setTitle(title, forState: .Normal)
    }
    
    func switchToCollectionViewController() {
        buttonAuthorize.setTitle("Back to App", forState: UIControlState.Normal)
        
        performSegueWithIdentifier("CollectionViewSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CollectionViewSegue" {
            (segue.destinationViewController as! CollectionViewController).delegate = self
        }
        
    }
    
    @IBAction func authorizeButton(sender: UIButton) {
        if( engine!.isSessionValid() ) {
            self.switchToCollectionViewController()
            return
        }
        let scope : InstagramKitLoginScope = [.Basic, .PublicContent, .Relationships, .Comments, .FollowerList]
        let authURL : NSURL = engine!.authorizationURLForScope(scope)
        self.webView.hidden = false
        self.webView.loadRequest( NSURLRequest(URL: authURL))
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        do {
            try engine!.receivedValidAccessTokenFromURL(request.URL!)
            self.switchToCollectionViewController()
        } catch {
            
        }
        
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        engine = InstagramEngine.sharedEngine()
        
        webView.hidden = true
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
