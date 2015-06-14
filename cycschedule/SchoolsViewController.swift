import Foundation
import UIKit

class SchoolsViewController: SelectionViewController {
    
    var season: String!
    
    override func viewDidLoad() {
        var postEndpoint = "http://x8-avian-bricolage-r.appspot.com/school/SchoolService.school"
        let timeout = 15
        let url = NSURL(string: postEndpoint)
        var err: NSError?
        var params = ["season":season] as Dictionary<String, String>
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
        if (segue.identifier == "toTeams") {
            var tvc = segue.destinationViewController as! TeamsViewController
            tvc.season = self.season
            tvc.school = TableData[lastSelectedIndexPath!.item]
        }
    }
    
    override func extract_json(data:NSString)
    {
        var parseError: NSError?
        let jsonData:NSData = data.dataUsingEncoding(NSASCIIStringEncoding)!
        let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &parseError)
        if (parseError == nil)
        {
            if let schools_obj = json as? NSDictionary
            {
                if let schools = schools_obj["schools"] as? NSArray
                {
                    for (var i = 0; i < schools.count ; i++ )
                    {
                        if let school_obj = schools[i] as? NSDictionary
                        {
                            if let season = school_obj["school"] as? String
                            {
                                super.TableData.append(season)
                            }
                        }
                    }
                }
            }
        }
        do_table_refresh();
    }
}
