
import UIKit
import Parse

class Interests: UIViewController, UITableViewDelegate, UITableViewDataSource, MenuTransitionManagerDelegate {
    
    var menuTransitionManager = MenuTransitionManager()
    var categorySelection: [String] = ["We", "Heart", "Swift"]
    @IBOutlet var categoryTable: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBAction func nextButton(sender: AnyObject) {
        self.performSegueWithIdentifier("signLogin", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let menuTableViewController = segue.destinationViewController as! MenuTableViewController
        menuTableViewController.transitioningDelegate = self.menuTransitionManager
        self.menuTransitionManager.delegate = self
        
        if segue.identifier == "logOutSegue" {
            
            PFUser.logOut()
            
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = UIColor(red:0.12, green:0.45, blue:0.73, alpha:1.0)
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationBar.translucent = false
        self.categoryTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Category Cell")
    }
    
    func tableView(categoryTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categorySelection.count;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = self.categoryTable.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
//        
//        cell.textLabel?.text = self.categorySelection[indexPath.row]
//        
//        return cell
//        //return UITableViewCell()
//    }
    
    func tableView(categoryTable: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.categoryTable.dequeueReusableCellWithIdentifier("Category Cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = self.categorySelection[indexPath.row]
        
        return UITableViewCell()
    
    }
    
    var interestItems = [""]
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("You selected cell #\(indexPath.row)!")
        PFUser.currentUser()?["interests"] = categorySelection[indexPath.row]
        PFUser.currentUser()?.save()
        
    }
    
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
   
    

    

}
