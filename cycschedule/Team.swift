import UIKit

class Team: NSObject {
    var name: String
    var teamId: Int32
    var grade: String
    var school: String
    
    
    init(name: String, teamId: Int32, grade: String, school: String) {
        self.name = name
        self.teamId = teamId
        self.grade = grade
        self.school = school
        super.init()
    }
}
