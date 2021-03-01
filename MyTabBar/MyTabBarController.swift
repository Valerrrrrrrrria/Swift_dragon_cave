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
    
    static var isLoad = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        barItem = item.tag
    }

    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let vc = viewController as? ViewController {
            
            // Create Date
            let date = Date()

            // Create Date Formatter
            let dateFormatter = DateFormatter()

            // Set Date Format
            dateFormatter.dateFormat = "YYYY-MM-dd"
            
            print ("MyTab:", date)
            
            switch barItem {
            case 0:
                vc.date = dateFormatter.string(from: date)
                break
            case 1:
                vc.date = dateFormatter.string(from: date.dayAfter)
                break
            case 2:
                vc.date = dateFormatter.string(from: date.dayBefore)
                break;
            default:
                vc.date = dateFormatter.string(from : date)
                break;
            }
        }
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
