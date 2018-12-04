//
//  DateFormatter.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/30/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

public enum DateFormat: String {
    case UTCFullDate = "yyyy-MM-dd'T'HH:mm:ss"
    case UTCFullDateZ = "yyyy-MM-dd'T'HH:mm:ssZ"
    case date = "dd.MM.yy"
    case dateTime = "dd.MM.yyyy', 'HH':'mm"
    case dayMonth = "d MMMM"
    case transactionfullDate = "yyyy/MM/dd' 'HH:mm:ss"
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

public class DeteFormatter {
    private var date: Date
    
    init(date: Date) {
        self.date = date
    }
    
    init?(timeStamp: String) {
        guard let number = Double(timeStamp) else {
            return nil
        }
        self.date = Date(timeIntervalSince1970: number)
    }
    
    public func formate(to: DateFormat) -> String {
        let dateFormatt = DateFormatter(formate: to)
        return dateFormatt.string(from: date)
    }
}
