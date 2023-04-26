//
//  Constants.swift
//  FlynautAssessment
//
//  Created by iMac on 24/04/23.
//

import Foundation

/// Describes URL Constants
struct URLConstant {
    static let BASEURL = "https://api.themoviedb.org/3/"
    static let imageURL = "https://picsum.photos/394/700/?image="
    static let videoURL = "Test"
    static let movieImageBaseURL = "https://image.tmdb.org/t/p/w500/"
}

/// Describes API endpoints
struct APIEndPoint {
    static let movieList = "/movie/now_playing?api_key=34c902e6393dc8d970be5340928602a7"
}

/// Describes Cell Identifiers
struct CellIdentifier {
    static let movieListCell = "movieListCell"
}

/// Describes View Controller Identifiers
struct VCIdentifier {
    static let StoryVC = "StoryVC"
    static let MovieListVC = "MovieListVC"
    static let PreviewVC = "PreviewVC"
    static let PageVC = "PageVC"
}


/// Describes all constant used within the Application
struct AppConstant {
    static let maxUserCount: Int = 3
    static let maxContentCount: Int = 5
    static let defaultContentTimeout: TimeInterval = 7.0
    static let maxPage: Int = 5
    
}

/// Describes user story data
struct UserStoryData {
    
    /// Story Data Generator
    /// - Returns: List of stories 
    func contentGenerator() -> [Content] {
        var userContents: [Content] = []
        
        for value in 0..<5 {
            let imgTemp = Int.random(in: 1..<30)
            let videoTemp = Int.random(in: 1..<4)
            if value%2 == 0{
                userContents.append(Content(path: URLConstant.imageURL+String(imgTemp), type: .image))
            } else {
                userContents.append(Content(path: URLConstant.videoURL+String(videoTemp)+".mp4", type: .video))
            }
        }
        return userContents
    }
}
