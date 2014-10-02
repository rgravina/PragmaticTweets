//
//  ViewController.swift
//  PragmaticTweets
//
//  Created by Robert Gravina on 9/26/14.
//  Copyright (c) 2014 Robert Gravina. All rights reserved.
//

import UIKit
import Social

let defaultAvatarURL = NSURL(string: "https://abs.twimg.com/sticky/default_profile_images/default_profile_6_200x200.png")

public class ViewController: UITableViewController {

  var parsedTweets: Array<ParsedTweet> = [
    ParsedTweet(tweetText: "Tweet A. This tweet is longer than the other tweets.", userName: "@pragprog", createdAt: "2014-10-01 23:31:51 JST", userAvatarURL: defaultAvatarURL),
    ParsedTweet(tweetText: "Tweet B. The second tweet.", userName: "@redqueencoder", createdAt: "2014-10-01 23:31:51 JST", userAvatarURL: defaultAvatarURL),
    ParsedTweet(tweetText: "Tweet C. The third.", userName: "@invalidname", createdAt: "2014-10-01 23:31:51 JST", userAvatarURL: defaultAvatarURL)
  ]

  override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1;
  }

  override public func tableView(_tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return parsedTweets.count
  }

  override public func tableView(_tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("CustomTweetCell") as ParsedTweetCell
    let parsedTweet = parsedTweets[indexPath.row]
    cell.userNameLabel.text = parsedTweet.userName
    cell.tweetTextLabel.text = parsedTweet.tweetText
    cell.createdAtLabel.text = parsedTweet.createdAt
    if parsedTweet.userAvatarURL != nil {
      cell.avatarImageView.image = UIImage(data: NSData(contentsOfURL: parsedTweet.userAvatarURL!))
    }
    return cell
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

  func reloadTweets() {
    self.tableView.reloadData()
  }

  override public func viewDidLoad() {
    super.viewDidLoad()
    self.reloadTweets()
  }
}

