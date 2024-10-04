//
//  AboutAbkeyVC.swift
//  AbKey
//
//  Created by Divyanah on 26/03/24.
//

import UIKit
import LZViewPager

class AboutAbkeyVC: UIViewController,LZViewPagerDelegate,LZViewPagerDataSource{
    
    @IBOutlet weak var viewPager: LZViewPager!
    
    @IBOutlet weak var lblHeadingTitle: UILabel!
    
    private var subControllers:[UIViewController] = []
    
    var premiumValueFromAboutAbkeyVC: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewPagerProperties()
        if premiumValueFromAboutAbkeyVC >= 1{
            lblHeadingTitle.text = "abKey Pro(Premium)"
        }else{
            lblHeadingTitle.text = "abKey Pro(Lite)"
        }
    }
    
    func viewPagerProperties(){
        viewPager.delegate = self
        viewPager.dataSource = self
        viewPager.hostController = self
        
        let welcomeVC = UIStoryboard(name: "Main", bundle:
        nil).instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
        
        let howToVC = UIStoryboard(name: "Main", bundle:
        nil).instantiateViewController(withIdentifier: "HowToVC") as! HowToVC
        
        let aggrementVC = UIStoryboard(name: "Main", bundle:
        nil).instantiateViewController(withIdentifier: "AggrementVC") as! AggrementVC
        
        welcomeVC.title = "WELCOME"
        howToVC.title = "HOW TO"
        aggrementVC.title = "AGGREMENT"
        
        subControllers = [welcomeVC, howToVC, aggrementVC]
        viewPager.reload()
    }
    
    func numberOfItems() -> Int {
        return self.subControllers.count
    }
    
    func controller(at index: Int) -> UIViewController {
        return subControllers[index]
    }
    
    func button(at index: Int) -> UIButton {
        let button = UIButton()
        button.setTitleColor(UIColor.white   , for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .black
        
        return button
    }
    
    func colorForIndicator(at index: Int) -> UIColor {
        return .tintColor
    }
    
    
    @IBAction func btnBackAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
