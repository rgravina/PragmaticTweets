//
//  ViewController.swift
//  PragmaticTweets
//
//  Created by Robert Gravina on 9/26/14.
//  Copyright (c) 2014 Robert Gravina. All rights reserved.
//

import UIKit
import Social

public class ViewController: UITableViewController {
  override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 5;
  }

  override public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Section \(section)"
  }

  override public func tableView(_tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section + 1;
  }
  
  override public func tableView (_tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
    cell.textLabel?.text = "Row \(indexPath.row)"
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
}

