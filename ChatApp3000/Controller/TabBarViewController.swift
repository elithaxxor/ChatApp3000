//
//  TabBarViewController.swift
//  ChatApp3000
//
//  Created by Adel Al-Aali on 1/19/23.
//

import UIKit

class TabBarViewController: UITabBarController {

    var chatList : UIViewController
    
    init (chatList: UIViewController) {
        self.chatList = chatList
        super.init (nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("coder has not been impimented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    // MARK: Setup tab icons on navbar (footer)
    //.. UINavigationController, and tabBarItem
    fileprivate func setupVC() {
        // let settings = SettingsViewController(chatList: chatList)
            let nav1 = UINavigationController(rootViewController: chatList)
         //   let nav2 = UINavigationController(rootViewController: settings)
        
            nav1.tabBarItem = UITabBarItem(title: "hi", image: UIImage(systemName: "messages"), tag: 1)
         //   nav2.tabBarItem = UITabBarItem(title: "tweakz",  image: UIImage(systemName: "gear"), tag: 2)

       //     setViewControllers([nav1, nav2], animated: true)
        }
//    
//    fileprivate func tabBarItem(nav1: Any?, nav2: Any?) -> UINavigationController {
//        nav1.tabBarItem = UITabBarItem(title: "hi", image: UIImage(systemName: "messages"), tag: 1)
//        nav2.tabBarItem = UITabBarItem(title: "tweakz",  image: UIImage(systemName: "gear"), tag: 2)
//        
//    }

}
