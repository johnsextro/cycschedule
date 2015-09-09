import UIKit
import CoreData
import iAd

protocol TeamSelectionDelegate: class {
    func teamSelected(team: Team, teamId: String)
}

class MasterViewController: UITableViewController, ADBannerViewDelegate {

    var lastSelectedIndexPath: NSIndexPath?
    var newTeam: Team!
    var teamController = TeamController()
    weak var delegate: TeamSelectionDelegate?
    var objects = [NSManagedObject](){
        didSet (objects) {
            if (objects.count > 0) {
                selectTeam(0)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    @IBAction func saveNewTeam(segue:UIStoryboardSegue) {
        objects = teamController.fetchAllTeams()
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        objects = teamController.fetchAllTeams()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.canDisplayBannerAds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TeamCell", forIndexPath: indexPath) as! UITableViewCell
        
        let team = objects[indexPath.row]
        cell.textLabel?.text = team.valueForKey("name") as? String
        cell.detailTextLabel?.text = team.valueForKey("grade") as? String
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            let teamToDelete = self.objects[indexPath.row]
            teamController.deleteMyTeam(teamToDelete)
            self.objects.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            if upcomingGamesIsLastRow() { deleteUpcomingGames() }
            
        default:
            return
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        showSelectedTeamsSchedule(indexPath.item)
    }
    
    func upcomingGamesIsLastRow() -> Bool {
        var retVal = false
        if objects.count == 1 {
            retVal = true
        }
        return retVal
    }
    
    func deleteUpcomingGames() {
        teamController.deleteMyTeam(self.objects[0])
        self.objects.removeAtIndex(0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }

    func showSelectedTeamsSchedule(selectedTeamIndex: Int) {
        if (objects.count > 0) {
            selectTeam(selectedTeamIndex)
            if let detailViewController = self.delegate as? DetailViewController {
                splitViewController?.showDetailViewController(detailViewController.navigationController, sender: nil)
            }
        }
    }
    
    func selectTeam(selectedTeamIndex: Int) {
        if (objects.count > 0) {
            let detailItem = objects[selectedTeamIndex] as NSManagedObject!
            let team = self.marshallObjectToTeam(detailItem)
            if (team.teamId == "-1") {
                var teamIds: String = ""
                for object: NSManagedObject in objects {
                    let tempTeam = self.marshallObjectToTeam(object)
                    teamIds += teamIds.isEmpty ? tempTeam.teamId : "," + tempTeam.teamId
                }
                self.delegate?.teamSelected(team, teamId: teamIds)
            } else {
                self.delegate?.teamSelected(team, teamId: team.teamId)
            }
        }
    }
    
    func marshallObjectToTeam(detailItem: NSManagedObject) -> Team {
        return Team(name: (detailItem.valueForKey("name") as? String)!, teamId: (detailItem.valueForKey("teamId") as? String)!, grade: (detailItem.valueForKey("grade") as? String)!, school: (detailItem.valueForKey("school") as? String)!)
    }
}

