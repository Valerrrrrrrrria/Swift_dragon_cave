//
//  Team.swift
//  1WIN
//
//  Created by Валерия Новикова on 20.02.2021.
//  Copyright © 2021 Валерия Новикова. All rights reserved.
//

import Foundation
import UIKit

struct Team : CustomStringConvertible {
    var name: String = ""
    var imgURL: String = ""
    var image: UIImage?
    
    var description : String {
        return "Team: \(name), imgURL: \(imgURL) \n"
    }
}
