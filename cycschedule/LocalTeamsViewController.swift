import UIKit

class LocalTeamsViewController: UITableViewController {
    var teams: [Team] = teamsData
    
    @IBAction func saveNewTeam(segue:UIStoryboardSegue) {
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TeamCell", forIndexPath: indexPath) as! UITableViewCell
        
        let team = teams[indexPath.row] as Team
        cell.textLabel?.text = team.name
        cell.detailTextLabel?.text = team.grade
        return cell
    }
}
