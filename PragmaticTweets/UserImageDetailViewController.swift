import UIKit

class UserImageDetailViewController: UIViewController {
  @IBOutlet weak var userImageView: UIImageView!
  
  var userImageURL : NSURL?
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if self.userImageURL != nil {
      self.userImageView.image = UIImage(data: NSData(contentsOfURL: self.userImageURL!)!)
    }
  }
}
