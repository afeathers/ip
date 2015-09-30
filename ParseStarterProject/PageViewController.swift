import UIKit
import Foundation
import CoreGraphics

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}


class PageViewController: UIViewController, UIPageViewControllerDataSource {
    
    @IBOutlet weak var pageControlElement: UIPageControl!
    
    private var pageViewController: UIPageViewController?
    var greenBackground = UIColor(red: 0x24, green: 0xBA, blue: 0x9A, alpha: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateControllersArray()
        createPageViewController()
        setupPageControl()

        // Do any additional setup after loading the view.
    }
    
    var controllers = [PageItemController]()
    
    
    func populateControllersArray() {
        for i in 0...1 {
            print("starting populatrecontrollersarray")
            let controller = storyboard!.instantiateViewControllerWithIdentifier("SignUp\(i)") as! PageItemController
            controller.itemIndex = i
            controllers.append(controller)
            print("SignUp\(i)")
        }
    }
    
    
    private func createPageViewController() {
        
        let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("PageController") as! UIPageViewController
        pageController.dataSource = self
        
        if !controllers.isEmpty {
            pageController.setViewControllers([controllers[0]], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.darkGrayColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
        appearance.backgroundColor = greenBackground
        print("setupPageControl function fired.")
    }
    
    
    // MARK: - UIPageViewControllerDataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let controller = viewController as? PageItemController {
            if controller.itemIndex > 0 {
                return controllers[controller.itemIndex - 1]
            }
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let controller = viewController as? PageItemController {
            if controller.itemIndex < controllers.count - 1 {
                print("I just scrolled right.")
                return controllers[controller.itemIndex + 1]
            }
        }
        return nil
    }
    
    
//    func displayPageForIndex(index: Int, animated: Bool = true) {
//        assert(index >= 0 && index < self.pages.count, "Error: Attempting to display a page for an out of bounds index")
//        
//        // nop if index == self.currentPageIndex
//        if self.currentPageIndex == index { return }
//        
//        if index < self.currentPageIndex {
//            self.setViewControllers([self.pages[index]], direction: .Reverse, animated: true, completion: nil)
//        } else if index > self.currentPageIndex {
//            self.setViewControllers([self.pages[index]], direction: .Forward, animated: true, completion: nil)
//        }
//        
//        self.currentPageIndex = index
//    }
    
    
//    func getItemController(itemIndex: Int) -> UIViewController? {
//        var vc: PageItemController? = nil
//        
//        switch itemIndex {
//        case 0:
//            // show an ImageViewController and pass data if needed
//            vc = self.storyboard!.instantiateViewControllerWithIdentifier("SignUp0") as! SignUp0
//            
//            vc!.itemIndex = itemIndex
//            
//        case 1:
//            // show any other ViewController and pass data if needed
//            vc = self.storyboard!.instantiateViewControllerWithIdentifier("SignUp1") as! SignUp1
//            
//            
//            vc!.itemIndex = itemIndex
//            
//            
//            
//        default:
//            break
//            
//        }
//        
//        
//        return vc
//    }
    
    // MARK: - Page Indicator
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return controllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }


}
