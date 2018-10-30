//
//  DateFormatter.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/30/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

enum DateFormat: String {
    case UTCFullDate = "yyyy-MM-dd'T'HH:mm:ss"
    case UTCFullDateZ = "yyyy-MM-dd'T'HH:mm:ssZ"
    case date = "dd.MM.yy"
    case dateTime = "dd.MM.yyyy', 'HH':'mm"
    case dayMonth = "d MMMM"
}

public class DateFormatterChanger {
    private let input: DateFormatter
    private let output: DateFormatter
    
    init(from: DateFormat, to: DateFormat) {
        input = DateFormatter(formate: from)
        output = DateFormatter(formate: to)
    }
    
    public func formate(date: String) -> String? {
        guard let inputDate = input.date(from: date) else { return nil }
        return output.string(from: inputDate)
    }
}

extension DateFormatter {
    convenience init(formate: DateFormat) {
        self.init()
        dateFormat = formate.rawValue
    }
}
