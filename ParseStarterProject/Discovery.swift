import UIKit
import Parse

class Discovery: UIViewController, MenuTransitionManagerDelegate {
    
    var menuTransitionManager = MenuTransitionManager()
    @IBOutlet var projectTitle: UILabel!
    @IBOutlet var projectImage: UIImageView!
    @IBOutlet var projectDescription: UILabel!

    var xFromCenter:CGFloat = 0
    var projectnames = [String]()
    var projectImages = [NSData]()
    var projectDescriptions = [String]()
    var currentProject = 0
    var currentProjectId = ""
    var acceptedOrRejected = ""
    

    @IBAction func saveButton(sender: AnyObject) {
        
        acceptedOrRejected = "accepted"
        PFUser.currentUser()?.addUniqueObjectsFromArray([currentProjectId], forKey:acceptedOrRejected)
        PFUser.currentUser()?.save()
        updateImage()

    }

    @IBAction func passButton(sender: AnyObject) {
        acceptedOrRejected = "rejected"
        PFUser.currentUser()?.addUniqueObjectsFromArray([currentProjectId], forKey:acceptedOrRejected)
        PFUser.currentUser()?.save()
        updateImage()
        
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        let sourceController = segue.sourceViewController as! MenuTableViewController
        self.title = sourceController.currentItem
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let menuTableViewController = segue.destinationViewController as! MenuTableViewController
        menuTableViewController.transitioningDelegate = self.menuTransitionManager
        self.menuTransitionManager.delegate = self
        
        if segue.identifier == "logOutSegue" {
            
            PFUser.logOut()
            
        }
    }
    
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        
        
        // create variables
        let translation = gesture.translationInView(self.view)
        let label = gesture.view!
        
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        
        let scale = min(200 / abs(xFromCenter), 1)
        
        
        var rotation = CGAffineTransformMakeRotation(xFromCenter / 300)
        
        var stretch = CGAffineTransformScale(rotation, scale, scale)
        
        label.transform = stretch
        
        // define whether or not project is liked or disliked
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            var acceptedOrRejected = ""
            
            
            if label.center.x < 100 {
                
                acceptedOrRejected = "rejected"
                //choiceMsg.text = "PASS"
                
            } else if label.center.x > self.view.bounds.width - 100 {
                
                acceptedOrRejected = "accepted"
                //choiceMsg.text = "KEEP"
                
            }
            
            if acceptedOrRejected != "" {
                
                PFUser.currentUser()?.addUniqueObjectsFromArray([currentProjectId], forKey:acceptedOrRejected)
                
                PFUser.currentUser()?.save()
                
            }
            
            
            rotation = CGAffineTransformMakeRotation(0)
            
            stretch = CGAffineTransformScale(rotation, 1, 1)
            
            label.transform = stretch
            
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            
            updateImage()
            
        }
        
        
    }

    func updateImage() {
        
        var query = PFUser.query()!
        var projectQuery = PFQuery(className: "project")
        var ignoredUsers = [""]
        if let acceptedUsers = PFUser.currentUser()?["accepted"]  {
            ignoredUsers += acceptedUsers as! Array
        }
        if let rejectedUsers = PFUser.currentUser()?["rejected"] {
            ignoredUsers += rejectedUsers as! Array
        }
        
        projectQuery.whereKey("objectId", notContainedIn: ignoredUsers)
        projectQuery.limit = 2
        projectQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let objects = objects as? [PFObject] {
                for object in objects {
                    print(object)
                    self.projectTitle.text = object["projectname"] as? String
                    self.projectDescription.text = object["projdesc"] as? String
                    self.currentProjectId = object.objectId!
                    let imageFile = object["image"] as! PFFile
                    imageFile.getDataInBackgroundWithBlock {
                        (imageData: NSData?, error: NSError?) -> Void in
                        if error != nil {
                            print(error)
                        } else {
                            if let data = imageData {
                                self.projectImage.image = UIImage(data: data)
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.barTintColor = UIColor(red:0.12, green:0.45, blue:0.73, alpha:1.0)
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.translucent = false
        self.title = "Discovery"
//        let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
//        projectImage.addGestureRecognizer(gesture)
//        projectImage.userInteractionEnabled = true
        updateImage()
        
        
        
    }
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    

}
