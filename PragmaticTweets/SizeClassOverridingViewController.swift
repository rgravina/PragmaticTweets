import UIKit

class SizeClassOverridingViewController: UIViewController {
  var embeddedSplitVC : UISplitViewController?
  var screenNameForOpenURL : String?

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "embedSplitViewSegue" {
      self.embeddedSplitVC = segue.destinationViewController as? UISplitViewController
    } else if segue.identifier == "ShowUserFromURLSegue" {
      if let userDetailVC = segue.destinationViewController as? UserDetailViewController {
      userDetailVC.screenName = self.screenNameForOpenURL }
    }
  }

  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    if size.width > 480.0 {
      let overrideTraits = UITraitCollection(horizontalSizeClass: .Regular)
      self.setOverrideTraitCollection(overrideTraits, forChildViewController: embeddedSplitVC!)
    } else {
      self.setOverrideTraitCollection(nil, forChildViewController: embeddedSplitVC!)
    }
  }

  @IBAction func unwindToSizeClassOverridingVC (segue: UIStoryboardSegue) {
  }
}
