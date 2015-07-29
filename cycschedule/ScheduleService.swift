import Foundation

class ScheduleService {
    
    func fetchTeamSchedule(teamId: String, callback: (Array< Game >) -> ()) {
        var postEndpoint: String = "http://x8-avian-bricolage-r.appspot.com/games/GamesService.games"
        let url = NSURL(string: postEndpoint)
        var params = ["team_id": teamId] as Dictionary<String, String>
        self.makeServiceCall(url!, params: params, callback: callback)
    }
    
    func fetchMultipleTeamSchedules(teamIds: String, callback: (Array< Game >) -> ()) {
        var postEndpoint: String = "http://x8-avian-bricolage-r.appspot.com/multigames/GamesMultiTeamService.games"
        let url = NSURL(string: postEndpoint)
        var params = ["team_ids": teamIds] as Dictionary<String, String>
        self.makeServiceCall(url!, params: params, callback: callback)
    }
    
    private func makeServiceCall(url: NSURL, params: Dictionary<String, String>, callback: (Array< Game >) -> ()) {
        var err: NSError?
        let timeout = 15
        var urlRequest = NSMutableURLRequest(URL: url)
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
                    callback(self.parseJSONIntoArrayofGames(NSString(data: data, encoding: NSASCIIStringEncoding)!))
                }else if data.length == 0 && error == nil{
                    println("Nothing was downloaded")
                } else if error != nil{
                    println("Error happened = \(error)")
                }
            }
        )
    }
    
    private func parseJSONIntoArrayofGames(data:NSString) -> Array< Game >{
        var parseError: NSError?
        var games:Array< Game > = Array < Game >()
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
                                var location: String = (game_obj["location"] as? String)!
                                var score: String = (game_obj["score"] as? String)!
                                var gameDate: String = (game_obj["game_date"] as? String)!
                                var gameTime: String = (game_obj["time"] as? String)!
                                
                                games.append(Game(gameId: gameId, gameDate: gameDate, gameTime: gameTime, opponent: awayTeam, location: location, score: score, home: homeTeam))
                            }
                        }
                    }
                }
            }
        }
        return games
    }
}