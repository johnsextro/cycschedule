
import UIKit

class DetailViewController: UITableViewController {
    
    var team: Team!
    var games:Array< Game > = Array < Game >()

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
        var postEndpoint: String = "http://x8-avian-bricolage-r.appspot.com/schedule/ScheduleService.schedule"
        let timeout = 15
        let url = NSURL(string: postEndpoint)
        var err: NSError?
        var params = ["team_id": team.teamId] as Dictionary<String, String>
        var urlRequest = NSMutableURLRequest(URL: url!)
        urlRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.HTTPMethod = "POST"
        let queue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(
            urlRequest,
            queue: queue,
            completionHandler: {(response: NSURLResponse!,
                data: NSData!,
                error: NSError!) in
                if data.length > 0 && error == nil{
                    let json = NSString(data: data, encoding: NSASCIIStringEncoding)
                    println(json)
                    self.extract_json(json!)
                }else if data.length == 0 && error == nil{
                    println("Nothing was downloaded")
                } else if error != nil{
                    println("Error happened = \(error)")
                }
            }
        )
        self.configureView()
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
                if let games_obj = schedule_obj["schedule"] as? NSDictionary
                {
                    if let gamesArray = games_obj["games"] as? NSArray
                    {
                        println(gamesArray.count)
                        for (var i = 0; i < gamesArray.count ; i++ )
                        {
                            if let game_obj = gamesArray[i] as? NSDictionary
                            {
                                var gameId: String = (game_obj["id"] as? String)!
                                var homeTeam: String = (game_obj["home"] as? String)!
                                var awayTeam: String = (game_obj["away"] as? String)!
                                var homeAway: String = (homeTeam == team.name ? "Home" : "Away")
                                var opponent: String = (homeTeam == team.name ? awayTeam : homeTeam)
                                var location: String = (game_obj["location"] as? String)!
                                var score: String = (game_obj["score"] as? String)!
                                var gameDate: String = (game_obj["game_date"] as? String)!
                                var gameTime: String = (game_obj["game_time"] as? String)!
                                
                                games.append(Game(gameId: gameId, gameDate: gameDate, gameTime: gameTime, homeAway: homeAway, opponent: opponent, location: location, score: score))
                                }
                            }
                        }
                    }
                }
            }
        }
//        do_table_refresh();
    }