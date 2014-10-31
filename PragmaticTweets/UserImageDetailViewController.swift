import UIKit

class UserImageDetailViewController: UIViewController {
  @IBOutlet weak var userImageView: UIImageView!

  var userImageURL: NSURL?
  var preGestureTransform: CGAffineTransform?

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if self.userImageURL != nil {
      self.userImageView.image = UIImage(data: NSData(contentsOfURL: self.userImageURL!)!)
    }
  }

  @IBAction func handlePanGesture(sender: UIPanGestureRecognizer) {
    if sender.state == .Began {
      self.preGestureTransform = self.userImageView.transform
    }
    if sender.state == .Began || sender.state == .Changed {
      let translation = sender.translationInView(self.userImageView)
      let translatedTransform = CGAffineTransformTranslate(self.preGestureTransform!, translation.x, translation.y)
      self.userImageView.transform = translatedTransform
    }
  }

  @IBAction func handleDoubleTapGesture(sender: UITapGestureRecognizer) {
    self.userImageView.transform = CGAffineTransformIdentity
  }

  @IBAction func handlePinchGesture(sender: UIPinchGestureRecognizer) {
    if sender.state == .Began {
      self.preGestureTransform = self.userImageView.transform
    }
    if sender.state == .Began || sender.state == .Changed {
      let scaledTransform = CGAffineTransformScale(self.preGestureTransform!, sender.scale, sender.scale)
      self.userImageView.transform = scaledTransform
    }
  }
}
