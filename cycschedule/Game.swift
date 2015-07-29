import Foundation

struct Game {
    var gameDateTime: NSDate
    var opponent: String
    var location: String
    var gameId: String
    var score: String
    var home: String
    
    init(gameId: String, gameDate: String, gameTime: String,
        opponent: String, location: String, score: String, home: String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "MM/dd/yyyy h:mm a"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        var dateString = gameDate + " " + gameTime
        var gameDateTime = dateStringFormatter.dateFromString(dateString)
        
        self.gameId = gameId
        self.opponent = opponent
        self.home = home
        self.location = location
        self.score = score
        self.gameDateTime = gameDateTime!
    }
}
