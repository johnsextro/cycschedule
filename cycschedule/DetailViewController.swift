import UIKit

class DetailViewController: UITableViewController {
    
    var games:Array< Game > = Array < Game >()
    let webService = ScheduleService()
    var teamId: String = ""
    var detailItem: Team! {
        didSet (team) {
            games.removeAll(keepCapacity: false)
            self.configureView()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GameCell", forIndexPath: indexPath) as! GameCustomCell
        let game = games[indexPath.row] as Game
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE, MMM d  h:mm a"
        
        let dateString = formatter.stringFromDate(game.gameDateTime)

        cell.gameDate.text = dateString
        cell.opponent.text = game.opponent + " at " + game.home
        cell.score.text = "Score: " + game.score
        cell.location.text = "Location: " + game.location
        
        let today = NSDate()
        if (game.gameDateTime.compare(today) == .OrderedAscending) {
            cell.gameDate.enabled   = false
            cell.opponent.enabled   = false
            cell.score.enabled      = false
            cell.location.enabled   = false
        } else {
            cell.gameDate.enabled   = true
            cell.opponent.enabled   = true
            cell.score.enabled      = true
            cell.location.enabled   = true
        }
        return cell
    }

    func configureView() {
        navigationItem.title = detailItem.name
        if (detailItem.teamId == "-1") {
            webService.fetchMultipleTeamSchedules(self.teamId, callback: self.handleServiceResponse)
        } else {
            webService.fetchTeamSchedule(self.teamId, callback: self.handleServiceResponse)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if ((detailItem) != nil) {
            self.configureView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func handleServiceResponse(games: Array< Game >) {
        self.games = games
        do_table_refresh()
    }
    
    
    func do_table_refresh()
    {        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
}

//TODO remove extension
extension DetailViewController: TeamSelectionDelegate {
    func teamSelected(team: Team, teamId: String) {
        self.teamId = teamId
        self.detailItem = team
    }
}