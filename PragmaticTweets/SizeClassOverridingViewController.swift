import UIKit

class SizeClassOverridingViewController: UIViewController {
  var embeddedSplitVC : UISplitViewController?

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "embedSplitViewSegue" {
      self.embeddedSplitVC = segue.destinationViewController as? UISplitViewController
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
}
