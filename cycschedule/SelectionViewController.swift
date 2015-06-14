import Foundation
import UIKit

class SelectionViewController: UITableViewController {
    
    var TableData:Array< String > = Array < String >()
    var lastSelectedIndexPath: NSIndexPath?
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        cell.accessoryType = .None
        cell.textLabel?.text = TableData[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        if indexPath.row != lastSelectedIndexPath?.row {
            if let lastSelectedIndexPath = lastSelectedIndexPath{
                let oldCell = tableView.cellForRowAtIndexPath(lastSelectedIndexPath)
                oldCell?.accessoryType = .None
            }
            
            let newCell = tableView.cellForRowAtIndexPath(indexPath)
            newCell?.accessoryType = .Checkmark
            
            lastSelectedIndexPath = indexPath
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
    }
    
    func extract_json(data:NSString)
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
                                TableData.append(season)
                            }
                        }
                    }
                }
            }
        }
        do_table_refresh();
    }
    
    func do_table_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
}
