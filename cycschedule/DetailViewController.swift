import UIKit

class DetailViewController: UITableViewController {
    
    var games:Array< Game > = Array < Game >()
    let scheduleService = ScheduleService()
    
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
        var vsOrAt = (game.homeAway == "Home" ? "vs." : "at")
        cell.opponent.text = vsOrAt + " " + game.opponent
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
        let teamId = detailItem.teamId
        scheduleService.fetchTeamSchedule(teamId, jsonParserFunction: self.extract_json)
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


    
    func extract_json(data:NSString)
    {
        var parseError: NSError?
        let jsonData:NSData = data.dataUsingEncoding(NSASCIIStringEncoding)!
        let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &parseError)
        if (parseError == nil)
        {
            if let schedule_obj = json as? NSDictionary
            {
                if let gamesArray = schedule_obj["games"] as? NSArray
                {
                    for (var i = 0; i < gamesArray.count ; i++ )
                    {
                        if let game_obj = gamesArray[i] as? NSDictionary
                        {
                            if let gameId = game_obj["game_id"] as? String
                            {
                                var homeTeam: String = (game_obj["home"] as? String)!
                                var awayTeam: String = (game_obj["away"] as? String)!
                                var homeAway: String = (homeTeam.rangeOfString(detailItem.name) != nil ? "Home" : "Away")
                                var opponent: String = (homeTeam.rangeOfString(detailItem.name) != nil ? awayTeam : homeTeam)
                                var location: String = (game_obj["location"] as? String)!
                                var score: String = (game_obj["score"] as? String)!
                                var gameDate: String = (game_obj["game_date"] as? String)!
                                var gameTime: String = (game_obj["time"] as? String)!
                                
                                games.append(Game(gameId: gameId, gameDate: gameDate, gameTime: gameTime, homeAway: homeAway, opponent: opponent, location: location, score: score))
                            }
                        }
                    }
                }
            }
        }
        do_table_refresh();
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
    func teamSelected(team: Team) {
        detailItem = team
    }
}