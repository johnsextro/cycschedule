import Foundation
import UIKit

var postEndpoint: String = "http://x8-avian-bricolage-r.appspot.com/season/SeasonService.season"

class SeasonsViewController: UITableViewController {
    
    var seasons: [String] = []

    override func viewDidLoad() {
        let timeout = 15
        let url = NSURL(string: postEndpoint)
        var urlRequest = NSMutableURLRequest(URL: url!)
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
//                    self.extract_json(json!)
                    println(json)
                }else if data.length == 0 && error == nil{
                    println("Nothing was downloaded")
                } else if error != nil{
                    println("Error happened = \(error)")
                }
            }
        )
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seasons.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TeamCell", forIndexPath: indexPath) as! UITableViewCell
        
        let season = seasons[indexPath.row] as String
        
        cell.textLabel?.text = "Season"
        return cell
    }
}
