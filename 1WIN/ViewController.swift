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
//import GoogleMobileAds

struct CachedMatches {
    var matches = [Match] ()
    var sport : String = ""
    var date : String = ""
    var cached = Date()
}

class ViewController: UIViewController {
    
    static var teams = Set<Team>()
    var matches = [Match]()
    
    var sportIs : String = "football" {
        didSet {
            viewUpdated()
        }
    }
    

    var date : String = ""
    
    var isLoad = false
    var index: String = ""
    
    private lazy var adsImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "ban")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
//    private lazy var bannerView: GADBannerView = {
//       let banner = GADBannerView(adSize: kGADAdSizeBanner)
//
//        return banner
//    }()
    
    private lazy var policyButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Privacy Policy", for: .normal)
        btn.setTitleColor(.darkGray, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(policyOnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func policyOnClick() {
        print("PRIVACY POLICY")
    
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "policy") as! PoliceViewController
                self.present(newViewController, animated: true, completion: nil)
        
    }
    
    private lazy var removeAdsButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Remove Ads", for: .normal)
        btn.setTitleColor(.darkGray, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(removeAdsOnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func removeAdsOnClick() {
        print("REMOVE ADS")
    }
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = view.center
        indicator.color = .white
        return indicator
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .darkGray
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TableViewCell.self, forCellReuseIdentifier: String(describing: TableViewCell.self))
        return tableView
    }()
        
    private var dataLoadTask : URLSessionDataTask?
    private var dataLoadTaskIndx = 0
    static private var dataLoadSession : URLSession {
        let cfg = URLSessionConfiguration.default
        return URLSession(configuration: cfg)
    }
    
    static private var cachedData = [String: CachedMatches]()
    
    override func viewWillLayoutSubviews() {
        awesomeHeader.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(awesomeHeader)
        self.view.addSubview(indicator)
        self.view.addSubview(policyButton)
        self.view.addSubview(removeAdsButton)
        self.view.addSubview(adsImage)
                
        let constraints = [
            awesomeHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            awesomeHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            awesomeHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            awesomeHeader.heightAnchor.constraint(equalToConstant: 125),
            
            policyButton.topAnchor.constraint(equalTo: awesomeHeader.topAnchor, constant: 25),
            policyButton.trailingAnchor.constraint(equalTo: awesomeHeader.trailingAnchor, constant: -10),
            
            removeAdsButton.topAnchor.constraint(equalTo: awesomeHeader.topAnchor, constant: 25),
            removeAdsButton.leadingAnchor.constraint(equalTo: awesomeHeader.leadingAnchor, constant: 10),
            
            adsImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            adsImage.heightAnchor.constraint(equalToConstant: 150),
            adsImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
            
            
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        //addBannerViewToView(bannerView)
    }
    
//    func addBannerViewToView(_ bannerView: GADBannerView) {
//     bannerView.translatesAutoresizingMaskIntoConstraints = false
//     view.addSubview(bannerView)
//     view.addConstraints(
//       [NSLayoutConstraint(item: bannerView,
//                           attribute: .bottom,
//                           relatedBy: .equal,
//                           toItem: view.safeAreaLayoutGuide.bottomAnchor,
//                           attribute: .bottom,
//                           multiplier: 1,
//                           constant: 0),
//        NSLayoutConstraint(item: bannerView,
//                           attribute: .centerX,
//                           relatedBy: .equal,
//                           toItem: view,
//                           attribute: .centerX,
//                           multiplier: 1,
//                           constant: 0)
//       ])
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewUpdated()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        
        self.view.addSubview(indicator)
        
        sportIs = "football"
    }
    
    func addTableView(){
    
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.backgroundColor = .darkGray
        
        tableView.reloadData()
        
        view.addSubview(tableView)
        
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            //tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 135),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: adsImage.topAnchor, constant: 0)
        
        ]
        
        tableView.isHidden = false
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func viewUpdated() {
        if date == "" {
            let df = DateFormatter()
            df.dateFormat = "YYYY-MM-dd"
            date = df.string(from : Date())
        }
        
        if let task = dataLoadTask {
            task.cancel()
            URLSession.shared.finishTasksAndInvalidate();
        }
        
        awesomeHeader.setActiveViewController(vc : self);
        displayUrl(date : date, sport: sportIs)
    }
    
    func displayUrl(date: String, sport: String) {
        
        indicator.startAnimating()
        
        
        dataLoadTaskIndx += 1
        matches.removeAll()
        tableView.isHidden = true
        
        print("I GET DATE \(date) and sport \(sport)")
        
        let myURLAdress = "https://www.sports.ru/\(sport)/match/\(date)/"
        
        if let cacheIndx = ViewController.cachedData.index(forKey: myURLAdress) {
            let cache = ViewController.cachedData[cacheIndx]
            
            self.matches = cache.value.matches
            self.indicator.stopAnimating()
            self.addTableView()
            
            if cache.value.cached.timeIntervalSinceNow > 60*60 {
                ViewController.cachedData.remove(at: cacheIndx)
            }
        }

        print("myURLAdress = https://www.sports.ru/\(sport)/match/\(date)/")
        
        // https://www.sports.ru/hockey/match/2021-02-18/
        // https://www.sports.ru/basketball/match/2021-02-18/
        
        let myURL = URL(string : myURLAdress)
        
        let taskIndx = dataLoadTaskIndx
        dataLoadTask = URLSession.shared.dataTask(with: myURL!) {
            [taskIndx, sportIs]
            myData, responce, error in
            
            guard error == nil else {
                DispatchQueue.main.async {
                    if taskIndx == self.dataLoadTaskIndx {
                        self.indicator.stopAnimating()
                    }
                }
                return;
            }
            
            var matches = [Match] ()
            
            let myHTMLString = String(data: myData!, encoding: String.Encoding.utf8)
            
            if let doc = try? HTML(html: myHTMLString!, encoding: String.Encoding.utf8) {
                
                let ts     = doc.xpath("//td[@class='alLeft gray-text']").makeIterator()
                let titles = doc.xpath("//div[@class='rel']").makeIterator()
                let scores = doc.xpath("//span[@class='s-left'] | //span[@class='s-right']").makeIterator()
                let imIt   = doc.xpath("//div[@class='rel']").makeIterator()
                
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
                        if let firstUrl =  first.at_xpath("//a[@class='player']") {
                            m.firstCommandURL = firstUrl["href"] ?? "unknown"
                        }
                        
                        if let secondUrl =  second.at_xpath("//a[@class='player']") {
                            m.secondCommandURL = secondUrl["href"] ?? "unknown"
                        }

                        // Если объект Team с именем еще не создан, то создать и загрузить изображение
                        
                        
                        DispatchQueue.main.async {
                            [m, sportIs] as [Any]
                                                    
                            var firstTeam = Team()
                            firstTeam.name = m.firstCommand;
                            firstTeam.sport = sportIs
                            
                            if !ViewController.teams.contains(firstTeam) {
                                DispatchQueue.global(qos: .background).async {
                                    self.displayHTMLForImage(
                                        name: m.firstCommand
                                        , url: m.firstCommandURL
                                        , sport : sportIs
                                    )
                                }
                            }
                            
                            var secondTeam = Team()
                            secondTeam.name = m.secondCommand;
                            secondTeam.sport = sportIs

                            if !ViewController.teams.contains(secondTeam) {
                                DispatchQueue.global(qos : .background).async {
                                    self.displayHTMLForImage(
                                        name: m.secondCommand
                                        , url: m.secondCommandURL
                                        , sport : sportIs
                                    )
                                }
                            }
                        }
                    
                        
                    } else {
                        break;
                    }
                    
                    if (m.status == "Не начался" || m.status == "Перенесен") {
                        matches.append(m)
                        continue;
                    }
                    
                    if let first = scores.next(), let second = scores.next() {
                        m.firstScore  = first.text  ?? "unknown"
                        m.secondScore = second.text ?? "unknown"
                    } else {
                        break
                    }
                    
                    matches.append(m)
                }
                
                // MARK: - Add Table View
                
                print(matches)
                
                DispatchQueue.main.async {
                    if taskIndx == self.dataLoadTaskIndx {
                        self.matches = matches
                        self.indicator.stopAnimating()
                        self.addTableView()
                    }
                    
                    if error == nil {
                        ViewController.cachedData.updateValue(
                            CachedMatches (
                                matches: matches
                                , sport: sportIs
                                , date: date
                                , cached: Date()
                            )
                            , forKey: myURLAdress)
                    }
                }
            }
        }
        
        if let task = dataLoadTask {
            task.resume();
        }
    }
    
    func displayHTMLForImage(name: String, url: String, sport : String) {
        

        //print("NAME IS \(name)")
        
        if (url.isEmpty || url == "unknown") {
            var team = Team()
            team.name = name
            team.image = UIImage(named: "load")
            team.sport = sport
        } else {
            var imageURL = ""
            
            let myURL = URL(string: url)
            
            let session = URLSession.shared
            let task = session.dataTask(with: myURL!) {
                myData, response, error in
                
                
                guard error == nil else {
                    return
                }
                
                var team = Team()
                team.name = name
                
                let myHTMLString = String(data: myData!, encoding: String.Encoding.utf8)
                
              
                        if let doc = try? HTML(html: myHTMLString!, encoding: String.Encoding.utf8) {
                            
                            let imIt = doc.xpath("//link[@rel='image_src']").makeIterator()
                            
                            if let first = imIt.next() {
                                if (first["href"] == "https://www.sports.ru/i/logo/facebook_app_logo_sports.png") {
                                    team.imgURL = "noURL"
                                    team.image  = UIImage(named: "load")
                                    team.sport  = sport
                                } else {
                                    imageURL    = first["href"]  ?? "noURL"
                                    team.imgURL = imageURL
                                    team.image  = self.downloadImage(url: imageURL)
                                    team.sport  = sport
                                }
                            }
                            
                            DispatchQueue.main.async {
                                [team]
                                
                                ViewController.teams.insert(team)

                                var rows = [IndexPath]()
                                
                                for (i, m) in self.matches.enumerated() {
                                    if team.name == m.firstCommand {
                                        rows.append(IndexPath(row : 0, section : i));
                                    }
                                    
                                    if team.name == m.secondCommand {
                                        rows.append(IndexPath(row : 0, section : i));
                                    }
                                }
                                
                                if !rows.isEmpty {
                                    self.tableView.beginUpdates()
                                    //self.tableView.reloadSections(rows, with: .none)
                                    self.tableView.reloadRows(at: rows, with: .none)
                                    self.tableView.endUpdates()
                                }
                            }
                        }
                   
                
             //print(self.teams)
            }
            
            task.resume()
        }
    
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
        return 250
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zero
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //return CGFloat.leastNormalMagnitude
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
        return matches.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: TableViewCell = tableView.dequeueReusableCell(
        withIdentifier: String(describing: TableViewCell.self),
        for: indexPath) as! TableViewCell
        
        if matches.count < indexPath.section {
            return cell
        }
        
        let m = matches[indexPath.section];
        
        var firstTeam = Team()
        firstTeam.name = m.firstCommand;
        firstTeam.sport = sportIs
        
        var firstImage = UIImage(named : "load")
        if let indx = ViewController.teams.firstIndex(of: firstTeam) {
            firstImage = ViewController.teams[indx].image ?? UIImage(named : "load")
        }
        
        var secondTeam = Team()
        secondTeam.name = m.secondCommand;
        secondTeam.sport = sportIs
        
        var secondImage = UIImage(named : "load")
        if let indx = ViewController.teams.firstIndex(of: secondTeam) {
            secondImage = ViewController.teams[indx].image ?? UIImage(named : "load")
        }
        
        cell.match = matchSection(
            firstImage: firstImage
            , secondImage: secondImage
            , firstScore: matches[indexPath.section].firstScore
            , secondScore: matches[indexPath.section].secondScore
            , firstCommand: matches[indexPath.section].firstCommand
            , secondCommand: matches[indexPath.section].secondCommand
            , date: "\(matches[indexPath.section].date), \(matches[indexPath.section].time)"
            , status: matches[indexPath.section].status)
        
        cell.backgroundColor = .white
        cell.roundCornersWithRadius(45, top: true, bottom: true, shadowEnabled: true)
        
        return cell
    }

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

