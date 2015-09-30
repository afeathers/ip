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

class Deals: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    

    
    
    var dealList = []
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let productIds = PFUser.currentUser()?.objectForKey("accepted")
        
        let dealList: Array = ["\(productIds)"]
        print(dealList)
        
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
        return self.dealList.count;
    }
    
    
    func tableView(categoryTable: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("dealcell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = self.dealList[indexPath.row] as! String
        
        return UITableViewCell()
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("You selected cell #\(indexPath.row)!")

        
    }
    
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
