import UIKit
import Parse

class SignUp: UIViewController, UITextFieldDelegate, MenuTransitionManagerDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    var menuTransitionManager = MenuTransitionManager()
    
    var signupActive = true
    @IBOutlet var typeController: UISegmentedControl!
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var userImage: UIImageView!
    
    @IBAction func cancelButton(sender: AnyObject) {
        
        self.performSegueWithIdentifier("cancelRegister", sender: self)
    }
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func typeChanged(sender: UISegmentedControl) {
        
        
        switch typeController.selectedSegmentIndex {
            
            
        case 0:
            
            print("case 0")
            
            PFUser.currentUser()?["type"] = "buyer"
            PFUser.currentUser()?.save()
            
        case 1:
            print("case 1")
            PFUser.currentUser()?["type"] = "seller"
            PFUser.currentUser()?.save()
            
        case 2:
            print("case 2")
            PFUser.currentUser()?["type"] = "both"
            PFUser.currentUser()?.save()
            
        default: break
            
        }
        
    }
    
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            //self.dismissViewControllerAnimated(true, completion: nil)
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func registerButton(sender: AnyObject) {
        
        if usernameField.text == "" || passwordField.text == "" || emailField.text == "" {
            
            displayAlert("Error in Form", message: "Please fill in all of the fields")
            
        } else {
            
            
            // Show Activity Indicator on screen
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var errorMessage = "Please try again later."
            
            if signupActive == true {
                
                // Add user info to the parse database
                let user = PFUser.currentUser()!
                user.username = usernameField.text
                user.password = passwordField.text
                user.email = emailField.text
                
                // Sign Up.
                user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if error == nil {
                        print("signup successful")
                        //Signup Successful
                        
                        
                        PFUser.logInWithUsernameInBackground(self.usernameField.text!, password: self.passwordField.text!, block: { (user, error) -> Void in
                            
                            self.activityIndicator.stopAnimating()
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            
                            if user != nil {
                                // Logged in!
                                print("login successful")
                                //PageViewController.getItemController(1)
                            
                                self.performSegueWithIdentifier("signLogin", sender: self)
                                
                                var signupActive = false
                                
                                
                                
                            } else {
                                
                                if let errorString = error!.userInfo["error"] as? String {
                                    
                                    
                                    errorMessage = errorString
                                    
                                    
                                }
                                
                                self.displayAlert("Failed login", message: errorMessage)
                                
                            }
                            
                        })
                        
                    } else {
                        
                        if let errorString = error!.userInfo["error"] as? String {
                            
                            
                            errorMessage = errorString
                            
                            
                        }
                        
                        self.displayAlert("Failed Signup", message: errorMessage)
                        
                    }
                })
                
                
            } else {
                
                PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!, block: { (user, error) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if user != nil {
                        // Logged in!
                        print("login successful")
                        
                        self.performSegueWithIdentifier("signLogin", sender: self)
                        
                        
                    } else {
                        
                        if let errorString = error!.userInfo["error"] as? String {
                            
                            
                            errorMessage = errorString
                            
                            
                        }
                        
                        //self.displayAlert("Failed login", message: errorMessage)
                        
                    }
                    
                })
            }


        }
        
    }
    

    
    
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y -= 150
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 150
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        self.navigationBar.barTintColor = UIColor(red:0.12, green:0.45, blue:0.73, alpha:1.0)
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationBar.translucent = false
        
        self.usernameField.delegate = self
        self.passwordField.delegate = self
        self.emailField.delegate = self
        
        if PFUser.currentUser() != nil {
            
            PFUser.logOut()
            
        }
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, gender"])
        graphRequest.startWithCompletionHandler( {
          
            (connection, result, error) -> Void in
            if error != nil {
                print(error)
                
            } else if let result = result {
                print(result)
                
                PFUser.currentUser()?["id"] = result["id"]
                PFUser.currentUser()?["name"] = result["name"]
                PFUser.currentUser()?["gender"] = result["gender"]
                
                PFUser.currentUser()?.save()
                print("user saved")
                
                let userId = result["id"] as! String
                
                let facebookProfilePictureUrl = "https://graph.facebook.com/" + userId + "/picture?type=large"
                
                if let fbpicUrl = NSURL(string: facebookProfilePictureUrl) {
                    
                    if let data = NSData(contentsOfURL: fbpicUrl) {
                        
                        self.userImage.image = UIImage(data: data)
                        
                        let imageFile:PFFile = PFFile(data: data)
                        
                        PFUser.currentUser()?["image"] = imageFile
                        PFUser.currentUser()?.save()
                        
                    }
                    
                }
                
                
            }
            
        })
        
    }
    
    
    @IBAction func fbLoggingIn(sender: AnyObject) {
        
        let permissions = ["public_profile"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            
            (user: PFUser?, error: NSError?) -> Void in
            
            if let error = error {
                
                
            } else {
                
                if let user = user {
                    
                    print(user)
                    self.performSegueWithIdentifier("pageOne", sender: self)
                    var signupActive = false
                    
                }
            }
        }
        
        
    }


    func textFieldShouldReturn(usernameField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        
                
        // Pass the selected object to the new view controller.
        
        
    }
    

}
