import UIKit
import Parse
import FBSDKCoreKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    var signupActive = true
    var currentUser = ""

    @IBOutlet var usernameLogin: UITextField!
    @IBOutlet var passwordLogin: UITextField!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func signUp(sender: AnyObject) {
        
        self.performSegueWithIdentifier("showSignupScreen", sender: self)
        
    }
    
    
    @IBAction func normLogin(sender: AnyObject) {
        
        if usernameLogin.text == "" || passwordLogin.text == ""  {
            
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
        
            PFUser.logInWithUsernameInBackground(usernameLogin.text!, password: passwordLogin.text!, block: { (user, error) -> Void in
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if user != nil {
                // Logged in!
                print("login successful")
                
                self.performSegueWithIdentifier("loggedIn", sender: self)
                
                var signupActive = false
                
                
                
            } else {
                
                if let errorString = error!.userInfo["error"] as? String {
                    
                    
                    errorMessage = errorString
                    
                    
                }
                
                self.displayAlert("Failed login", message: errorMessage)
                
            }
            
        })
        }
        
    }
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PFUser.logOut()
        print("\(PFUser.currentUser())")
        
        self.usernameLogin.delegate = self
        self.passwordLogin.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }
    
    func textFieldShouldReturn(usernameLogin: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        
        
        if let username = PFUser.currentUser()?.username {
            
            performSegueWithIdentifier("showSigninScreen", sender: self)
            
        }
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

