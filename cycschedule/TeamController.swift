import Foundation
import CoreData
import UIKit

class TeamController {
    let appDelegate: AppDelegate
    let managedContext: NSManagedObjectContext
    
    init() {
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = appDelegate.managedObjectContext!
    }
   
    func saveMyTeam(myteam: Team) {
        checkForUpcomingGamesTeamAndAddIfNecessary()
        saveTeam(myteam)
    }
    
    func saveTeam(myteam: Team) {
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
    
    func deleteMyTeam(teamToDelete: NSManagedObject) {
        let predicate = NSPredicate(format: "teamId == %@", (teamToDelete.valueForKey("teamId") as? String)!)
        
        let fetchRequest = NSFetchRequest(entityName: "Teams")
        fetchRequest.predicate = predicate
        
        let fetchedEntities = self.managedContext.executeFetchRequest(fetchRequest, error: nil) as! [NSManagedObject]
        let entityToDelete = fetchedEntities.first
        self.managedContext.deleteObject(entityToDelete!)
        
        self.managedContext.save(nil)
    }
    
    func fetchAllTeams() ->  [NSManagedObject] {
        let fetchRequest = NSFetchRequest(entityName:"Teams")
        var error: NSError?
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            return results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
            return []
        }
    }
    
    func checkForUpcomingGamesTeamAndAddIfNecessary() {
        let results = fetchAllTeams()
        if results.count < 2 {
            saveTeam(Team(name: "Upcoming Games", teamId: "-1", grade: "In the next 7 days", school: ""))
        }
    }
}
