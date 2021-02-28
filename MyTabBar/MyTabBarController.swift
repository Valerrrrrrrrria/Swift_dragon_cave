//
//  MyTabBarController.swift
//  1WIN
//
//  Created by Валерия Новикова on 19.02.2021.
//  Copyright © 2021 Валерия Новикова. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController, UITabBarControllerDelegate {
    var barItem: Int = -1;
    var viewController: ViewController = ViewController()
    var header = ReusableHeader()
    static var isLoad = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        barItem = item.tag
        
        print(item.tag)
        
        switch ViewController.sportIs {
        case "football":
            
            for header: ReusableHeader in ViewController.headers {
                header.changeSegment(segment: 0)
            }
            
            break;

        case "hockey":
            
            for header: ReusableHeader in ViewController.headers {
                header.changeSegment(segment: 1)
            }
            
            break;

        case "basketball":
            
            for header: ReusableHeader in ViewController.headers {
                header.changeSegment(segment: 2)
            }
            
            break;
            
        default:
            break;
        }
        
        switch (item.tag) {
        case 0:
            ViewController.myDate = ViewController.today
            print(ViewController.myDate)
            print(ViewController.sportIs)
            print("UPLOADING")
            viewController.displayUrl(date: ViewController.today, sport: ViewController.sportIs)
            
            break
        case 1:
            ViewController.myDate = ViewController.dayAfter
            print(ViewController.myDate)
            print(ViewController.sportIs)
            print("UPLOADING")
            viewController.displayUrl(date: ViewController.dayAfter, sport: ViewController.sportIs)
            
            break
        case 2:
            ViewController.myDate = ViewController.dayBefore
            print(ViewController.myDate)
            print(ViewController.sportIs)
            print("UPLOADING")
            viewController.displayUrl(date: ViewController.dayBefore, sport: ViewController.sportIs)
            
            break
        default:
            break
        }
        
    }

    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //print("Selected view controller")
    }
    
    final func getBarItem() -> Int {
        return barItem
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
