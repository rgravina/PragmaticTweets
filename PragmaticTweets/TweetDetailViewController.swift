import UIKit
import MapKit

class TweetDetailViewController: UIViewController {
  @IBOutlet weak var userImageButton: UIButton!
  @IBOutlet weak var userRealNameLabel: UILabel!
  @IBOutlet weak var userScreenNameLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var tweetLocationMapView: MKMapView!

  var tweetIdString : String? {
    didSet {
      reloadTweetDetails()
    }
  }

  func reloadTweetDetails() {
  }
}
