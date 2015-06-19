import Foundation

struct Game {
    var gameDateTime: NSDate
    var homeAway: String
    var opponent: String
    var location: String
    var gameId: String
    var score: String
    
    init(gameId: String, gameDate: String, gameTime: String, homeAway: String,
    opponent: String, location: String, score: String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "MM/dd/yyyy h:mm a"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        var dateString = gameDate + " " + gameTime
        var gameDateTime = dateStringFormatter.dateFromString(dateString)
        
        self.gameId = gameId
        self.opponent = opponent
        self.location = location
        self.score = score
        self.homeAway = homeAway
        self.gameDateTime = gameDateTime!
    }
}
