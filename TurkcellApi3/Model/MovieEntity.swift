//
//  MovieEntity.swift
//  TurkcellApi3
//
//  Created by Sefa Aycicek on 19.09.2024.
//

import UIKit

class MovieEntityResponse : Codable {
    let success : Bool
    let result : [MovieEntity]
    
    init(success: Bool, result: [MovieEntity]) {
        self.success = success
        self.result = result
    }
}

class MovieEntity: Codable {
    let title : String
    let year : String
    let type : String
    let poster : String
    
    enum CodingKeys : String, CodingKey {
        case title = "Title"
        case year = "Year"
        case type = "Type"
        case poster = "Poster"
    }
    
    init(title: String, year: String, type: String, poster: String) {
        self.title = title
        self.year = year
        self.type = type
        self.poster = poster
    }
}
