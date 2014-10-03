import UIKit
import Social
import Accounts

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
    let accountStore = ACAccountStore()
    let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    accountStore.requestAccessToAccountsWithType(twitterAccountType,
      options: nil,
      completion: {
        (Bool granted, NSError error) -> Void in
        if (!granted) {
          println("access not granted")
        } else {
          let twitterAccounts = accountStore.accountsWithAccountType(twitterAccountType)
          if twitterAccounts.count == 0 {
            println("no twitter accounts configured")
            return
          } else {
            let twitterParams = [
              "count" : "100"
            ]
            let twitterAPIURL = NSURL.URLWithString("https://api.twitter.com/1.1/statuses/home_timeline.json")
            let request = SLRequest(forServiceType: SLServiceTypeTwitter,
              requestMethod: SLRequestMethod.GET,
              URL: twitterAPIURL,
              parameters :twitterParams
            )
            request.account = twitterAccounts[0] as ACAccount
            request.performRequestWithHandler({
              (NSData data, NSHTTPURLResponse urlResponse, NSError error) -> Void in
              self.handleTwitterData(data, urlResponse: urlResponse, error: error)
            })
          }
        }
      }
    )
  }

  override public func viewDidLoad() {
    super.viewDidLoad()
    reloadTweets()
    var refresher = UIRefreshControl()
    refresher.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
    self.refreshControl = refresher
  }

  @IBAction func handleRefresh(sender: AnyObject?) {
    self.parsedTweets.append(
      ParsedTweet(tweetText: "New row", userName: "@refresh", createdAt: NSDate().description, userAvatarURL: defaultAvatarURL)
    )
    reloadTweets()
    refreshControl!.endRefreshing()
  }

  func handleTwitterData (data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) {
    if let validData = data {
    println ("handleTwitterData, \(validData.length) bytes")
  } else {
    println ("handleTwitterData received no data") }
  }
}

