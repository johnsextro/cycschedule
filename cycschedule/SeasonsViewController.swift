import Foundation
import UIKit

class SeasonsViewController: SelectionViewController {
    
    override func viewDidLoad() {
        var postEndpoint: String = "http://x8-avian-bricolage-r.appspot.com/season/SeasonService.season"
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
        if (segue.identifier == "toSchools") {
            var svc = segue.destinationViewController as! SchoolsViewController
            svc.season = TableData[lastSelectedIndexPath!.item]
        }
    }
    
    override func extract_json(data:NSString)
    {
        var parseError: NSError?
        let jsonData:NSData = data.dataUsingEncoding(NSASCIIStringEncoding)!
        let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &parseError)
        if (parseError == nil)
        {
            if let seasons_obj = json as? NSDictionary
            {
                if let seasons = seasons_obj["seasons"] as? NSArray
                {
                    for (var i = 0; i < seasons.count ; i++ )
                    {
                        if let season_obj = seasons[i] as? NSDictionary
                        {
                            if let season = season_obj["season"] as? String
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
