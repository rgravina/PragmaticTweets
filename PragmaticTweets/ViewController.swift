//
//  ViewController.swift
//  PragmaticTweets
//
//  Created by Robert Gravina on 9/26/14.
//  Copyright (c) 2014 Robert Gravina. All rights reserved.
//

import UIKit
import Social

public class ViewController: UIViewController {

    @IBOutlet weak public var twitterWebView: UIWebView!

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.reloadTweets()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handleTweetButtonTapped(sender: UIButton) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let tweetVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            let message = NSBundle.mainBundle().localizedStringForKey(
                "I just finished the first project in iOS 8 SDK Development. #pragsios8",
                value: "",
                table: nil)
            tweetVC.setInitialText(message)
            self.presentViewController(tweetVC, animated: true, completion: nil)
        } else {
            println("Can't send tweet")
        }
    }

    @IBAction func handleShowMyTweetsButtonTapped(sender: UIButton) {
        self.reloadTweets()
    }

    func reloadTweets() {
        self.twitterWebView.loadRequest(NSURLRequest(URL: NSURL(string: "http://twitter.com/pragprog")))
    }
}

