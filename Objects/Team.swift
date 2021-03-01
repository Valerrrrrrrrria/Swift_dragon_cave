//
//  Team.swift
//  1WIN
//
//  Created by Валерия Новикова on 20.02.2021.
//  Copyright © 2021 Валерия Новикова. All rights reserved.
//

import Foundation
import UIKit

struct Team : CustomStringConvertible, Hashable {
    var name: String = ""
    var imgURL: String = ""
    var image: UIImage?
    var sport: String = ""
    
    var description : String {
        return "Team: \(name), imgURL: \(imgURL) \n"
    }
    
    static func == (lhs: Team, rhs: Team) -> Bool {
        return lhs.name == rhs.name && lhs.sport == rhs.sport
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(sport)
    }
}
