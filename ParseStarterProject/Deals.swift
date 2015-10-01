//
//  DealsViewController.swift
//  IP INDEX
//
//  Created by Alex Jacobs on 9/30/15.
//  Copyright © 2015 Parse. All rights reserved.
//

struct ProductInfo
{
    var productName:String!
    
}

import UIKit
import Parse

@IBDesignable
class Deals: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    var productIds = [""]
    var productNames = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Ask for the current user's follow list.
        let Ids = PFUser.currentUser()?.objectForKey("accepted") as! NSArray
        print(Ids)
        
        let query = PFQuery(className: "project")
        query.whereKey("objectId", containedIn: Ids as [AnyObject])
        
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError!) -> Void in
            
            if error == nil {
                
                // query successful - display number of rows found
                println("Successfully retrieved \(objects.count) people")
                
                // print name & hair color of each person found
                for object in objects {
                    
                    
                    self.productNames.append(object.projectname!) as! NSString
                    self.productIds.append(object.objectId!) as NSString
                    
                    
                }
            } else {
                
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }
        
        
        
                        //self.productNames.append(object.projectname!) as! String
                        //self.productIds.append(object.objectId!)
       
        
        
        
        // Navigation bar setup
        self.navigationBar.barTintColor = UIColor(red:0.12, green:0.45, blue:0.73, alpha:1.0)
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationBar.translucent = false

        return
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(categoryTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productIds.count;
    }
    
    
    func tableView(categoryTable: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("dealcell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = self.productIds[indexPath.row] as! String
        
        return UITableViewCell()
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("You selected cell #\(indexPath.row)!")

        
    }
    
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
