//
//  TableViewCell.swift
//  1WIN
//
//  Created by Валерия Новикова on 24.02.2021.
//  Copyright © 2021 Валерия Новикова. All rights reserved.
//

import UIKit

struct matchSection {
    let firstImage: UIImage?
    let secondImage: UIImage?
    let firstScore: String
    let secondScore: String
    let firstCommand: String
    let secondCommand: String
    let date: String
    let status: String
    
}

class TableViewCell: UITableViewCell {
    
    var match: matchSection? {
        didSet {
            firstImage.image = match?.firstImage
            secondImage.image = match?.secondImage
            score.text = "\(match!.firstScore ?? "") : \(match!.secondScore ?? "")"
            firstCommand.text = match?.firstCommand
            secondCommand.text = match?.secondCommand
            date.text = match?.date
            status.text = match?.status
        }
    }
    
    private let firstImage: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .black
        
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private let secondImage: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .black
        
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private let firstCommand: UITextView = {
        let iv = UITextView()
        //iv.textContainer.lineBreakMode = .byTruncatingTail
        //iv.textContainer.maximumNumberOfLines = 2
        iv.textColor = .black
        iv.textAlignment = .center
        iv.font = UIFont.systemFont(ofSize: 16, weight: .black)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let secondCommand: UITextView = {
        let iv = UITextView()
        //iv.textContainer.lineBreakMode = .byTruncatingTail
        //iv.textContainer.maximumNumberOfLines = 2
        iv.textColor = .black
        iv.textAlignment = .center
        iv.font = UIFont.systemFont(ofSize: 16, weight: .black)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let score: UITextView = {
        let iv = UITextView()
        iv.textColor = .darkGray
        iv.textAlignment = .center
        iv.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let date: UITextView = {
        let iv = UITextView()
        iv.textColor = .darkGray
        iv.textAlignment = .center
        iv.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let status: UITextView = {
        let iv = UITextView()
        iv.textColor = .darkGray
        iv.textAlignment = .center
        iv.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        //contentView.backgroundColor = .green
        
        contentView.addSubviews(firstImage, secondImage, firstCommand, secondCommand, score, date, status)
        
        let contraints = [
            
            firstImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            firstImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            firstImage.widthAnchor.constraint(equalToConstant: 100),
            firstImage.heightAnchor.constraint(equalToConstant: 100),
            
            firstCommand.topAnchor.constraint(equalTo: firstImage.bottomAnchor, constant: 0),
            firstCommand.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            firstCommand.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            firstCommand.widthAnchor.constraint(equalToConstant: 200),
            
            secondImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            secondImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            secondImage.widthAnchor.constraint(equalToConstant: 100),
            secondImage.heightAnchor.constraint(equalToConstant: 100),
            
            secondCommand.topAnchor.constraint(equalTo: secondImage.bottomAnchor, constant: 0),
            secondCommand.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            secondCommand.widthAnchor.constraint(equalToConstant: 200),
            secondCommand.bottomAnchor.constraint(equalTo: firstCommand.bottomAnchor),
            
            score.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100),
            score.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            score.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            score.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            score.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            
            date.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -75),
            date.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            date.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            date.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            date.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),

            status.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50),
            status.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            status.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            status.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            status.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor)
            
        ]
        
        NSLayoutConstraint.activate(contraints)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
}

//extension UIView {
//    
//    /// Method adds shadow and corner radius for top of view by default.
//    ///
//    /// - Parameters:
//    ///   - top: Top corners
//    ///   - bottom: Bottom corners
//    ///   - radius: Corner radius
//    func roundCornersWithRadius(_ radius: CGFloat, top: Bool? = true, bottom: Bool? = true, shadowEnabled: Bool = true) {
//        var maskedCorners = CACornerMask()
//        
//        if shadowEnabled {
//            clipsToBounds = true
//            layer.masksToBounds = false
//            layer.shadowOpacity = 0.7
//            layer.shadowColor = UIColor(white: 0.0, alpha: 1.0).cgColor
//            layer.shadowRadius = 4
//            layer.shadowOffset = CGSize(width: 4, height: 4)
//        }
//        
//        switch (top, bottom) {
//        case (true, false):
//            maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//        case (false, true):
//            maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
//        case (true, true):
//            maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
//        default:
//            break
//        }
//        
//        layer.cornerRadius = radius
//        layer.maskedCorners = maskedCorners
//    }
//    
//}

