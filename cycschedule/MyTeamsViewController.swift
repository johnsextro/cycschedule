import UIKit
import CoreData

class MyTeamsViewController: UITableViewController {
    var teams = [NSManagedObject]()
    var newTeam: Team!
    var lastSelectedIndexPath: NSIndexPath?
    let appDelegate: AppDelegate
    let managedContext: NSManagedObjectContext
    
    @IBAction func saveNewTeam(segue:UIStoryboardSegue) {
        self.fetchResults()
        tableView.reloadData()
    }
    
    required init!(coder aDecoder: NSCoder!) {
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = appDelegate.managedObjectContext!
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchResults()
    }
    
    override func viewDidLoad() {
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
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

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            let teamToDelete = self.teams[indexPath.row]
            deleteMyTeam(teamToDelete)
            self.teams.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

        default:
            return
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showDetail") {
            var dvc = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
            let team = teams[tableView.indexPathForSelectedRow()!.item]
            dvc.team = Team(name: (team.valueForKey("name") as? String)!, teamId: (team.valueForKey("teamId") as? String)!, grade: (team.valueForKey("grade") as? String)!, school: (team.valueForKey("school") as? String)!)
        }
    }
    
    func deleteMyTeam(teamToDelete: NSManagedObject) {
        let predicate = NSPredicate(format: "teamId == %@", (teamToDelete.valueForKey("teamId") as? String)!)
        
        let fetchRequest = NSFetchRequest(entityName: "Teams")
        fetchRequest.predicate = predicate
        
        let fetchedEntities = self.managedContext.executeFetchRequest(fetchRequest, error: nil) as! [NSManagedObject]
        let entityToDelete = fetchedEntities.first
        self.managedContext.deleteObject(entityToDelete!)
        
        self.managedContext.save(nil)
    }
    
    func fetchResults() {
        let fetchRequest = NSFetchRequest(entityName:"Teams")
        var error: NSError?
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            teams = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
}
