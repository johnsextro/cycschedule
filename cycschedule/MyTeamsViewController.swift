import UIKit
import CoreData

class MyTeamsViewController: UITableViewController {
    var teams = [NSManagedObject]()
    var newTeam: Team!
    var lastSelectedIndexPath: NSIndexPath?

    

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    


    
    

}
