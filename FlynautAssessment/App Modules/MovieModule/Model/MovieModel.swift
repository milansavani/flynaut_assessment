//
//  MovieModel.swift
//  FlynautAssessment
//
//  Created by iMac on 24/04/23.
//

import Foundation

/// Describe Codale movie data from API
struct MovieData: Codable {
    var page: Int
    var results: [MovieModel]
    var total_pages: Int
}

/// Describe codable movie model
struct MovieModel: Codable {
    let id: Int
    let title: String
    let poster_path: String
    var isFavourite: Bool? = false
}
