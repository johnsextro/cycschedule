import UIKit

class MyTeamsViewController: UITableViewController {
    var teams: [Team] = teamsData
    var newTeam: Team!
    var lastSelectedIndexPath: NSIndexPath?
    
    @IBAction func saveNewTeam(segue:UIStoryboardSegue) {
        teams.append(newTeam)
        tableView.reloadData()
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
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        println("clicking the tableview row")
//        
//        if indexPath.row != lastSelectedIndexPath?.row {
//            if let lastSelectedIndexPath = lastSelectedIndexPath{
//                let oldCell = tableView.cellForRowAtIndexPath(lastSelectedIndexPath)
//            }
//            
//            let newCell = tableView.cellForRowAtIndexPath(indexPath)
//            lastSelectedIndexPath = indexPath
//        }
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var dvc = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
        println(teams[tableView.indexPathForSelectedRow()!.item].name)
        dvc.team = teams[tableView.indexPathForSelectedRow()!.item]
    }
}
