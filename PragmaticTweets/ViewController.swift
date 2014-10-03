import UIKit
import Social
import Accounts

// constant for default avatar URL
let defaultAvatarURL = NSURL(string: "https://abs.twimg.com/sticky/default_profile_images/default_profile_6_200x200.png")

public class ViewController: UITableViewController {
  
  // sample tweet data... will replace with real tweets
  // var since the array needs to be mutable
  var parsedTweets: Array<ParsedTweet> = []

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

  //
  // Parse and log the Twitter JSON
  //
  func handleTwitterData (data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) {
    if let dataValue = data {
      // NSError can be nil (so is an optional)
      var parseError: NSError? = nil
      // NSJSONSerialization might also return nil (so is an optional)
      let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(dataValue, options: NSJSONReadingOptions(0), error: &parseError)
      if parseError != nil {
        return
      }
      if let jsonArray = jsonObject as? Array<Dictionary<String,AnyObject>> {
        self.parsedTweets.removeAll(keepCapacity: true)
        for tweetDict in jsonArray {
          let parsedTweet = ParsedTweet()
          parsedTweet.tweetText = tweetDict["text"] as? NSString
          parsedTweet.createdAt = tweetDict["created_at"] as? NSString
          let userDict = tweetDict["user"] as NSDictionary
          parsedTweet.userName = userDict["name"] as? NSString
          parsedTweet.userAvatarURL = NSURL(string: userDict["profile_image_url"] as NSString!)
          self.parsedTweets.append(parsedTweet)
        }
        // We shoudln't reload the table on any other thread that the main thread (which this isn't running in).
        // So, run it on the main queue.
        dispatch_async(dispatch_get_main_queue(), {
          () -> Void in
            self.tableView.reloadData()
        })
      }

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
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),{
        () -> Void in
        let avatarImge = UIImage(data: NSData(contentsOfURL: parsedTweet.userAvatarURL!))
        dispatch_async(dispatch_get_main_queue(), {
          if cell.userNameLabel.text == parsedTweet.userName {
            cell.avatarImageView.image = avatarImge
          } else {
            println("Cell has been reused. Skipping.")
          }
        })
      })
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

