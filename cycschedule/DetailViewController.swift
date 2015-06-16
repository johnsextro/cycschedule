
import UIKit

class DetailViewController: UITableViewController {
    
    var team: Team!

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
//        if let detail: AnyObject = self.detailItem {
//            if let label = self.detailDescriptionLabel {
//                label.title = detail.description
//            }
//        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = team.name
        
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

