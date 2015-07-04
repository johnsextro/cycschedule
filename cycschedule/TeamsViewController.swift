import Foundation
import UIKit
import CoreData

class TeamsViewController: SelectionViewController {

    var season: String!
    var school: String!
    var teamsArray = [Team]()
    var team = [NSManagedObject]()
    
    override func viewDidLoad() {
        var postEndpoint: String = "http://x8-avian-bricolage-r.appspot.com/coach/CoachService.coach"
        let timeout = 15
        let url = NSURL(string: postEndpoint)
        var err: NSError?
        var params = ["season":season, "school":school] as Dictionary<String, String>
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
                    self.extract_json(json!)
                }else if data.length == 0 && error == nil{
                    println("Nothing was downloaded")
                } else if error != nil{
                    println("Error happened = \(error)")
                }
            }
        )
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "SaveNewTeam") {
            var master = segue.destinationViewController.topViewController as! MasterViewController
            master.newTeam = teamsArray[lastSelectedIndexPath!.item]
            saveMyTeam(teamsArray[lastSelectedIndexPath!.item])
        }
    }
    
    override func extract_json(data:NSString)
    {
        var parseError: NSError?
        let jsonData:NSData = data.dataUsingEncoding(NSASCIIStringEncoding)!
        let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &parseError)
        if (parseError == nil)
        {
            if let coaches_obj = json as? NSDictionary
            {
                if let teams = coaches_obj["coaches"] as? NSArray
                {
                    for (var i = 0; i < teams.count ; i++ )
                    {
                        if let team_obj = teams[i] as? NSDictionary
                        {
                            if let team = team_obj["name"] as? String
                            {
                                TableData.append(team)
                                var teamName: String = (team_obj["name"] as? String)!
                                var teamId: String = (team_obj["team_id"] as? String)!
                                var grade: String = (team_obj["grade"] as? String)!
                                var school: String = (team_obj["school"] as? String)!
                                
                                teamsArray.append(Team(name: teamName, teamId: teamId
                                , grade: grade, school: school))
                            }
                        }
                    }
                }
            }
        }
        do_table_refresh();
    }
    
    func saveMyTeam(myteam: Team) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Teams", inManagedObjectContext: managedContext)
        let team = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        team.setValue(myteam.name, forKey: "name")
        team.setValue(myteam.teamId, forKey: "teamId")
        team.setValue(myteam.grade, forKey: "grade")
        team.setValue(myteam.school, forKey: "school")
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
    }
}
