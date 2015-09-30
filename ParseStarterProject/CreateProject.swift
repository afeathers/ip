//
//  CreateProject.swift
//  IPINDEX
//
//  Created by Alex Jacobs on 8/6/15.


import UIKit
import Parse

class CreateProduct: UIViewController, UITextFieldDelegate, UITextViewDelegate, MenuTransitionManagerDelegate {
    
    var menuTransitionManager = MenuTransitionManager()
    
    @IBOutlet weak var navigationBar: UINavigationBar!
 
    @IBOutlet var rightBarItem: UIBarButtonItem!
    
    @IBOutlet var productTitle: UITextField!
    @IBOutlet var productURL: UITextField!
    @IBOutlet var productCompanyName: UITextField!
    @IBOutlet var productSumm: UITextView!
    
    var objId = ""
   
    
    @IBAction func nextCreate(sender: UIBarButtonItem) {
        
        let post = PFObject(className: "Product")
        
        post["userId"] = PFUser.currentUser()?.objectId!
        post["Product_Title"] = productTitle.text
        post["Product_URL"] = productURL.text
        post["Product_Company_Name"] = productCompanyName.text
        post["Product_Summary"] = productSumm.text
        
        if printedOption.on {
            
            post["Printable"] = true
            
        } else {
           
            post.saveInBackgroundWithBlock { (success, error) -> Void in
                
//                self.activityIndicator.stopAnimating()
//                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if error == nil {
//                    self.displayAlert("Upload Successful", message: "Your image has been uploaded successfully.")
                    print("success")
                    var objId = post.objectId
                    self.performSegueWithIdentifier("productDetails", sender: self)
                } else {
                    
                    self.displayAlert("Upload Failed", message: "Your upload has failed, please try again.")
                    
                }
            }
            
            
        }
    }
    
    @IBOutlet var printedOption: UISwitch!
    
    func retainObject() {
        
    }

    @IBAction func cancelButton(sender: AnyObject) {
        
        self.performSegueWithIdentifier("cancelCreate", sender: self)
    }
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
    func textFieldShouldReturn(projectTitle: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textView(projectSumm: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            projectSumm.resignFirstResponder()
            return false
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "menu" {
            
            let menuTableViewController = segue.destinationViewController as! MenuTableViewController
            menuTableViewController.transitioningDelegate = self.menuTransitionManager
            self.menuTransitionManager.delegate = self
            
        }
        
        
        if segue.identifier == "logOutSegue" {
            
            PFUser.logOut()
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationBar.barTintColor = UIColor(red:0.12, green:0.45, blue:0.73, alpha:1.0)
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationBar.translucent = false
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);

        self.productTitle.delegate = self
        self.productURL.delegate = self
        self.productCompanyName.delegate = self
        self.productSumm.delegate = self
        
        
        

        // Do any additional setup after loading the view.
    }
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y -= 150
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 150
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
