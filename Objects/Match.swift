//
//  Match.swift
//  1WIN
//
//  Created by Валерия Новикова on 19.02.2021.
//  Copyright © 2021 Валерия Новикова. All rights reserved.
//

import Foundation
import UIKit

class Match : CustomStringConvertible {
    var date: String = "" // Add Date
    var time: String = ""
    var status: String = ""
    var firstCommand: String = ""
    var secondCommand: String = ""
    var firstScore: String = ""
    var secondScore: String = ""
    var firstCommandURL: String = ""
    var secondCommandURL: String = ""
    
    
    var description : String {
        return "Date: \(date) Match: \(time), status: \(status), \(firstCommand) VS \(secondCommand), score: \(firstScore) : \(secondScore), firstCommandURL: \(firstCommandURL), secondCommandURL: \(secondCommandURL) \n"
    }
}
