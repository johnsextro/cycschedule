import Foundation

class ScheduleService {
    
//    func fetchAllTeamSchedules(teams: [String: String], callback: (Array< Game >) -> ()) {
//        callback(collectGamesForMultipleTeams(teams))
//    }
//    
//    private func collectGamesForMultipleTeams(teams: [String: String]) -> Array< Game > {
//        var allGames:Array< Game > = Array < Game >()
//        for (teamId, teamName) in teams {
//            allGames += self.buildArrayofGamesForTeam(teamId, teamName: teamName)
//        }
//        return allGames
//    }
    
    func fetchTeamSchedule(teamId: String, teamName: String, callback: (Array< Game >) -> ()) {
        var postEndpoint: String = "http://x8-avian-bricolage-r.appspot.com/games/GamesService.games"
        let timeout = 15
        let url = NSURL(string: postEndpoint)
        var err: NSError?
        var params = ["team_id": teamId] as Dictionary<String, String>
        var urlRequest = NSMutableURLRequest(URL: url!)
        urlRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.HTTPMethod = "POST"
        let queue = NSOperationQueue()
        var gameArray: Array< Game > = Array< Game >()
        NSURLConnection.sendAsynchronousRequest(
            urlRequest,
            queue: queue,
            completionHandler: {(response: NSURLResponse!,
                data: NSData!,
                error: NSError!) in
                if data.length > 0 && error == nil{
                    callback(self.parseJSONIntoArrayofGames(NSString(data: data, encoding: NSASCIIStringEncoding)!, teamName: teamName))
                }else if data.length == 0 && error == nil{
                    println("Nothing was downloaded")
                } else if error != nil{
                    println("Error happened = \(error)")
                }
            }
        )
    }
    
    

    
    private func parseJSONIntoArrayofGames(data:NSString, teamName: String) -> Array< Game >{
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
                                var homeAway: String = (homeTeam.rangeOfString(teamName) != nil ? "Home" : "Away")
                                var opponent: String = (homeTeam.rangeOfString(teamName) != nil ? awayTeam : homeTeam)
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
        return games
    }
}