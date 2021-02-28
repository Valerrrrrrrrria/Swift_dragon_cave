//
//  ReusableHeader.swift
//  1WIN
//
//  Created by Валерия Новикова on 18.02.2021.
//  Copyright © 2021 Валерия Новикова. All rights reserved.
//

import UIKit

class ReusableHeader: UIView {
    
    let nibName = "Header"
    var contentView:UIView?
    var selectedIndex: String = ""
    var viewController: ViewController = ViewController()
   
    @IBOutlet weak var winText: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl! {
        didSet {
            segmentControl.defaultConfiguration()
        }
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        
        switch segmentControl.selectedSegmentIndex {
            case 0:
                selectedIndex = "Football"
                ViewController.sportIs = "football"
                print(ViewController.sportIs)
                print(ViewController.myDate)
            case 1:
                selectedIndex = "Hockey"
                ViewController.sportIs = "hockey"
                print(ViewController.myDate)
                print(ViewController.sportIs)
            case 2:
                selectedIndex = "Basketball"
                ViewController.sportIs = "basketball"
                print(ViewController.myDate)
                print(ViewController.sportIs)
            default:
                break
        }
        viewController.displayUrl(date: ViewController.myDate, sport: ViewController.sportIs)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // Нужно изменять SelectedItem
    public func changeSegment(segment: Int) {
       segmentControl.selectedSegmentIndex = segment
    }
    
    func getHeaderItem() -> String {
        return selectedIndex
    }
    
    
    func commonInit() {
         guard let view = loadViewFromNib() else { return }
         view.frame = self.bounds
         self.addSubview(view)
         contentView = view
        
        
     }
    
     func loadViewFromNib() -> UIView? {
         let bundle = Bundle(for: type(of: self))
         let nib = UINib(nibName: nibName, bundle: bundle)
         return nib.instantiate(withOwner: self, options: nil).first as? UIView
     }
    
    

    /*
     override func viewDidLoad() {
         super.viewDidLoad()
         // Do any additional setup after loading the view.
     }
     */
}

extension UISegmentedControl
{
    
    func defaultConfiguration(font: UIFont = UIFont.systemFont(ofSize: 14), color: UIColor = UIColor.white)
    {
        let defaultAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
        setTitleTextAttributes(defaultAttributes, for: .normal)
    }

    func selectedConfiguration(font: UIFont = UIFont.boldSystemFont(ofSize: 14), color: UIColor = UIColor.red)
    {
        let selectedAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
        setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}
