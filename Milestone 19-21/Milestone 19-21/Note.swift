//
//  Note.swift
//  Milestone 19-21
//
//  Created by Евгения Зорич on 13.03.2023.
//

import Foundation

class Note: Codable {
    var text: String
    var date: Date

    init(text: String, date: Date) {
        self.text = text
        self.date = date
    }
}
