import UIKit

class TweetDetailViewController: UIViewController {
  var tweetIdString : String? {
    didSet {
      reloadTweetDetails()
    }
  }

  func reloadTweetDetails() {
    println("Reloading tweet details for: \(tweetIdString!)")
  }
}
