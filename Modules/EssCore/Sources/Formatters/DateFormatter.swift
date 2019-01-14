//
//  DateFormatter.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/30/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssModel

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
