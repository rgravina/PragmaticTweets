import UIKit
import Social
import Accounts

// constant for default avatar URL
let defaultAvatarURL = NSURL(string: "https://abs.twimg.com/sticky/default_profile_images/default_profile_6_200x200.png")

public class ViewController: UITableViewController {
  
  // sample tweet data... will replace with real tweets
  // var since the array needs to be mutable
  var parsedTweets: Array<ParsedTweet> = [
    ParsedTweet(tweetText: "Tweet A. This tweet is longer than the other tweets.", userName: "@pragprog", createdAt: "2014-10-01 23:31:51 JST", userAvatarURL: defaultAvatarURL),
    ParsedTweet(tweetText: "Tweet B. The second tweet.", userName: "@redqueencoder", createdAt: "2014-10-01 23:31:51 JST", userAvatarURL: defaultAvatarURL),
    ParsedTweet(tweetText: "Tweet C. The third.", userName: "@invalidname", createdAt: "2014-10-01 23:31:51 JST", userAvatarURL: defaultAvatarURL)
  ]

  //
  // On load - load up timeline and setup refresh control
  //
  override public func viewDidLoad() {
    super.viewDidLoad()
    reloadTweets()
    var refresher = UIRefreshControl()
    refresher.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
    self.refreshControl = refresher
  }

  //
  // Handle loading/reloading of tweets. Authenticates and gets timeline via API.
  //
  func reloadTweets() {
    // get the account store
    let accountStore = ACAccountStore()
    // store twitter account type as we'll use this a couple of times'
    let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    accountStore.requestAccessToAccountsWithType(twitterAccountType,
      options: nil,
      completion: {
        (Bool granted, NSError error) -> Void in
        if (!granted) {
          println("access not granted")
        } else {
          // get all twitter accounts
          let twitterAccounts = accountStore.accountsWithAccountType(twitterAccountType)
          if twitterAccounts.count == 0 {
            println("no twitter accounts configured")
            return
          } else {
            // make an API call to get the first 100 tweets
            let twitterParams = [
              "count" : "100"
            ]
            // construct a NSURL from a string
            let twitterAPIURL = NSURL.URLWithString("https://api.twitter.com/1.1/statuses/home_timeline.json")
            // create a request for the Social API
            let request = SLRequest(forServiceType: SLServiceTypeTwitter,
              requestMethod: SLRequestMethod.GET,
              URL: twitterAPIURL,
              parameters: twitterParams
            )
            // set the account. Need to cast it because accountStore.accountsWithAccountType
            // returns AnyObject
            request.account = twitterAccounts[0] as ACAccount
            // perform the request
            request.performRequestWithHandler({
              (NSData data, NSHTTPURLResponse urlResponse, NSError error) -> Void in
              self.handleTwitterData(data, urlResponse: urlResponse, error: error)
            })
          }
        }
      }
    )
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


  //
  // UITableViewDelegate methods
  //

  // This is just a list of tweets. The layout of each cell is customised so more than one section isn't needed
  override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1;
  }

  // The number of tweets
  override public func tableView(_tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return parsedTweets.count
  }

  // Get tweet at index
  override public func tableView(_tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    // Get custom cell and tweet
    let cell = tableView.dequeueReusableCellWithIdentifier("CustomTweetCell") as ParsedTweetCell
    let parsedTweet = parsedTweets[indexPath.row]
    // Set values
    cell.userNameLabel.text = parsedTweet.userName
    cell.tweetTextLabel.text = parsedTweet.tweetText
    cell.createdAtLabel.text = parsedTweet.createdAt
    if parsedTweet.userAvatarURL != nil {
      // contruct an image from the data at the url
      cell.avatarImageView.image = UIImage(data: NSData(contentsOfURL: parsedTweet.userAvatarURL!))
    }
    return cell
  }

  // ----

  // Not used for now...
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

