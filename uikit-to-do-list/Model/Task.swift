//
//  Task.swift
//  uikit-to-do-list
//
//  Created by Pedro Franco on 12/02/24.
//

import Foundation

struct Task: Codable {
    let id: String
    let sender: String
    let name: String
    let description: String
    let date: String 
}
