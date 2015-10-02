//
//  DealsViewController.swift
//  IP INDEX
//
//  Created by Alex Jacobs on 9/30/15.
//  Copyright © 2015 Parse. All rights reserved.
//



import UIKit
import Parse

@IBDesignable
class Deals: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    var productIds = [String]()
    var productNames = [String]()
    var imageFiles = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.productIds.removeAll(keepCapacity: true)
        self.productNames.removeAll(keepCapacity: true)
        
        // Ask for the current user's list of saved projects.
        let Ids = PFUser.currentUser()?.objectForKey("accepted") as! NSArray
        print(Ids)
        
        // Requesting the Project objects based on the Ids retrieved.
        let projectRetrieval = PFQuery(className: "project")
        projectRetrieval.whereKey("objectId", containedIn: Ids as [AnyObject])
        projectRetrieval.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if let objects = objects {
                for object in objects {
                    //Append the productNames array with retrieved projectnames
                    self.productNames.append(object["projectname"] as! String)
                    
                    print("Projectnames: \(self.productNames)")
                    
                }
                
            }
            self.tableView.reloadData()
            
        })
        
        
        // Navigation bar setup
        self.navigationBar.barTintColor = UIColor(red: 0.1216, green: 0.4471, blue: 0.7294, alpha: 1.0)
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationBar.translucent = false

        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productNames.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("dealcell", forIndexPath: indexPath) as! DealCell
        
        cell.productName.text = self.productNames[indexPath.row] 
        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("You selected cell #\(indexPath.row)!")

        
    }
    
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
