//
//  Content.swift
//  FlynautAssessment
//
//  Created by iMac on 25/04/23.
//

import Foundation
import Foundation


/// Describe Content type image/video
enum ContentType {
    case image
    case video
}


/// Describe content object
struct Content {
    var path: String
    var type: ContentType
}


/// Describe userstory data
struct UserStory {
    var name: String
    var image: String
    var content: [Content]
}

