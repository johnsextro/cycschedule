import UIKit

class GameCustomCell: UITableViewCell {

    @IBOutlet weak var gameDate: UILabel!
    @IBOutlet weak var homeAway: UILabel!
    @IBOutlet weak var opponent: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var score: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
