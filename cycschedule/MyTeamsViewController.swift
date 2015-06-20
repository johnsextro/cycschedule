import UIKit
import CoreData

class MyTeamsViewController: UITableViewController {
    var teams = [NSManagedObject]()
    var newTeam: Team!
    var lastSelectedIndexPath: NSIndexPath?
    
    @IBAction func saveNewTeam(segue:UIStoryboardSegue) {
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName:"Teams")
    
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            teams = results
            println(teams.count)
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TeamCell", forIndexPath: indexPath) as! UITableViewCell
        
        let team = teams[indexPath.row]
        cell.textLabel?.text = team.valueForKey("name") as? String
        cell.detailTextLabel?.text = team.valueForKey("grade") as? String
        return cell
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showDetail") {
            var dvc = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
            let team = teams[tableView.indexPathForSelectedRow()!.item]
            dvc.team = Team(name: (team.valueForKey("name") as? String)!, teamId: (team.valueForKey("teamId") as? String)!, grade: (team.valueForKey("grade") as? String)!, school: (team.valueForKey("school") as? String)!)
        }
    }
}
