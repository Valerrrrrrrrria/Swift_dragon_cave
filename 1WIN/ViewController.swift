//
//  ViewController.swift
//  1WIN
//
//  Created by Валерия Новикова on 18.02.2021.
//  Copyright © 2021 Валерия Новикова. All rights reserved.
//

// Сделать таблицу для уже имеющихся данных
// Загружать данные при каждом изменении состояния
// Продумать сохранение данных, чтобы не грузить каждый раз, мб у матчей сделать еще тип: футбол, баскетбол, хоккей и состояние: прошедший, идет, будущий, тогда сможем сохранять и длеать вывод по состоянию

import UIKit
import Kanna

class ViewController: UIViewController {
    
    var teams = [Team]()
    var matches = [Match]()
    static var headers = [ReusableHeader]()
    static var tables = [UITableView]()
    static var today = "", dayBefore = "", dayAfter = "", myDate = ""
    static var sportIs = ""
    var isLoad = false
    
    lazy var header: ReusableHeader = {
        let header = ReusableHeader()
        
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    var index: String = ""
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = view.center
        indicator.color = .white
        
        return indicator
    }()
        
    private lazy var tableView: UITableView = {
            let tableView = UITableView(frame: .zero, style: .plain)
            tableView.backgroundColor = .darkGray
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(TableViewCell.self, forCellReuseIdentifier: String(describing: TableViewCell.self))
            
            return tableView
        }()
    
    override func viewWillLayoutSubviews() {
        
        self.view.addSubview(header)
        self.view.addSubview(indicator)
        
        ViewController.headers.append(header)
        print("count is \(ViewController.headers.count)")
        
        let constraints = [
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 150)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        
        self.view.addSubview(indicator)
        
        // Create Date
        let date = Date()

        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "YYYY-MM-dd"

        // Convert Date to String
        ViewController.today = dateFormatter.string(from: date)
        ViewController.dayBefore = dateFormatter.string(from: date.dayBefore)
        ViewController.dayAfter = dateFormatter.string(from: date.dayAfter)
        
        ViewController.sportIs = "football"
        ViewController.myDate = ViewController.today
        
        
        
        if (!MyTabBarController.isLoad) {
            displayUrl(date: ViewController.today, sport: ViewController.sportIs)
            MyTabBarController.isLoad = true
        }
        
    }
    
    func addTableView(){
    
        view.addSubview(tableView)
        ViewController.tables.append(tableView)
        
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func displayUrl(date: String, sport: String) {
        
        indicator.startAnimating()
        
        teams.removeAll()
        matches.removeAll()
        
        print("I GET DATE \(date) and sport \(sport)")
        
        let myURLAdress = "https://www.sports.ru/\(sport)/match/\(date)/"
        
        print("myURLAdress = https://www.sports.ru/\(sport)/match/\(date)/")
        
        // https://www.sports.ru/hockey/match/2021-02-18/
        // https://www.sports.ru/basketball/match/2021-02-18/
        
        let myURL = URL(string: myURLAdress)
        
        let session = URLSession.shared
        let task = session.dataTask(with: myURL!) {
            myData, responce, error in
            
            guard error == nil else {return}
            
            let myHTMLString = String(data: myData!, encoding: String.Encoding.utf8)
            
            if let doc = try? HTML(html: myHTMLString!, encoding: String.Encoding.utf8) {
                
                let ts     = doc.xpath("//td[@class='alLeft gray-text']").makeIterator()
                let titles = doc.xpath("//div[@class='rel']").makeIterator()
                let scores = doc.xpath("//span[@class='s-left'] | //span[@class='s-right']").makeIterator()
                let imIt   = doc.xpath("//a[@class='player']").makeIterator()
                
                while true
                {
                    let m = Match()
                    
                    m.date = date
                    
                    if let time = ts.next(), let status = ts.next() {
                        m.time   = time.text   ?? "unknown"
                        m.status = status.text ?? "unknown"
                    } else {
                        break;
                    }
                    
                    if let first = titles.next(), let second = titles.next() {
                        m.firstCommand  = first.text  ?? "unknown"
                        m.secondCommand = second.text ?? "unknown"
                        
                    } else {
                        break;
                    }
                    
                    if let first = imIt.next(), let second = imIt.next() {
                        m.firstCommandURL  = first["href"]  ?? "unknown"
                        m.secondCommandURL = second["href"] ?? "unknown"
                        
                        // Если объект Team с именем еще не создан, то создать и загрузить изображение
                        
                        if !self.checkIfTeamExist(name: m.firstCommand) {
                            self.displayHTMLForImage(name: m.firstCommand, url: m.firstCommandURL)
                        }

                        if !self.checkIfTeamExist(name: m.secondCommand) {
                            self.displayHTMLForImage(name: m.secondCommand, url: m.secondCommandURL)
                        }
                    
                        
                    } else {
                        break;
                    }
                    
                    if (m.status == "Не начался" || m.status == "Перенесен") {
                        self.matches.append(m)
                        continue;
                    }
                    
                    if let first = scores.next(), let second = scores.next() {
                        m.firstScore  = first.text  ?? "unknown"
                        m.secondScore = second.text ?? "unknown"
                    } else {
                        break
                    }
                    
                    self.matches.append(m)
                }
                
                // MARK: - Add Table View
                
                print(self.matches)
                
                DispatchQueue.main.async {
                    
                    self.indicator.stopAnimating()
                    self.addTableView()
                  
                    
                    //self.tableView.reloadData()
                    //self.tableView.reloadSections(IndexSet(integersIn: 0...0), with: .automatic)
                    
                    
                    //self.addTableView()
                }
            }
        }
        
        task.resume()
        
    }
    
    func checkIfTeamExist(name: String) -> Bool {
            
            for element: Team in teams {
                if element.name == name {
                    
                    return true
                    
                }
            }
           
        return false
        
    }
    
    func displayHTMLForImage(name: String, url: String) {
        
        var team = Team()
        team.name = name
        //print("NAME IS \(name)")
        
        var imageURL = ""
        
        let myURL = URL(string: url)
        
        let session = URLSession.shared
        let task = session.dataTask(with: myURL!) {
            myData, responce, error in
            
            guard error == nil else {return}
            
            let myHTMLString = String(data: myData!, encoding: String.Encoding.utf8)
            
            if let doc = try? HTML(html: myHTMLString!, encoding: String.Encoding.utf8) {
                
                let imIt = doc.xpath("//link[@rel='image_src']").makeIterator()
                
                if let first = imIt.next() {
                    imageURL    = first["href"]  ?? "noURL"
                    team.imgURL = imageURL
                    team.image  = self.downloadImage(url: imageURL)
                }
                
                self.teams.append(team)
            }
         //print(self.teams)
        }
        
        task.resume()
    
    }
    
    func downloadImage(url: String) -> UIImage? {
        let myURL = URL(string: url)

//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: myURL!) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        return image
//                    }
//                }
//            }
//        }
        
        
            if let data = try? Data(contentsOf: myURL!) {
                if let image = UIImage(data: data) {
                    
                        return image
                    
                }
            }
        
        
        return nil
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .zero
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        
        view.backgroundColor = .darkGray
        
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // return 10
        return matches.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return matches.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: TableViewCell = tableView.dequeueReusableCell(
        withIdentifier: String(describing: TableViewCell.self),
        for: indexPath) as! TableViewCell
        
        cell.roundCornersWithRadius(45)
        
        //cell.match = matchSection(firstImage: UIImage(named: "image"), secondImage: UIImage(named: "image"), firstCommand: "FirstCommand", secondCommand: "SecondCommand", date: "2021-02-24, 00:00:00")
        //var firstImage: UIImage?
        //var secondImage: UIImage?
        
        //firstImage = findImage(by: matches[indexPath.section].firstCommand)
        //secondImage = findImage(by: matches[indexPath.section].secondCommand)
        
        cell.match = matchSection(firstImage: UIImage(named: "image"), secondImage: UIImage(named: "image"), firstScore: matches[indexPath.section].firstScore, secondScore: matches[indexPath.section].secondScore, firstCommand: matches[indexPath.section].firstCommand, secondCommand: matches[indexPath.section].secondCommand, date: "\(matches[indexPath.section].date), \(matches[indexPath.section].time)", status: matches[indexPath.section].status)
        
        return cell
    }
    
//    func findImage(by name: String) -> UIImage {
//        for element: Team in teams {
//            if element.name == name { return element.image! }
//        }
//        return UIImage(named: "image")!
//    }
}

extension UIView {
    
    /// Method adds shadow and corner radius for top of view by default.
    ///
    /// - Parameters:
    ///   - top: Top corners
    ///   - bottom: Bottom corners
    ///   - radius: Corner radius
    func roundCornersWithRadius(_ radius: CGFloat, top: Bool? = true, bottom: Bool? = true, shadowEnabled: Bool = true) {
        var maskedCorners = CACornerMask()
        
        if shadowEnabled {
            clipsToBounds = true
            layer.masksToBounds = false
            layer.shadowOpacity = 0.7
            layer.shadowColor = UIColor(white: 0.0, alpha: 1.0).cgColor
            layer.shadowRadius = 4
            layer.shadowOffset = CGSize(width: 4, height: 4)
        }
        
        switch (top, bottom) {
        case (true, false):
            maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        case (false, true):
            maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        case (true, true):
            maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        default:
            break
        }
        
        layer.cornerRadius = radius
        layer.maskedCorners = maskedCorners
    }
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
