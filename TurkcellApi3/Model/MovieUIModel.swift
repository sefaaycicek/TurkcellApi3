//
//  MovieUIModel.swift
//  TurkcellApi3
//
//  Created by Sefa Aycicek on 19.09.2024.
//

import UIKit

class MovieUIModel {
    let title : String
    let year : String
    let type : String
    let poster : String
    
    init(title: String, year: String, type: String, poster: String) {
        self.title = title
        self.year = year
        self.type = type
        self.poster = poster
    }
}
