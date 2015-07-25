import Foundation
import CoreData
import UIKit

class TeamController {
   
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
