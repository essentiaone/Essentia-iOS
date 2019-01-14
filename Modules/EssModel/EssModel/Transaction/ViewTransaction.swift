//
//  ViewTransaction.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/23/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

public struct ViewTransaction {
    public var hash: String
    public var address: String
    public var ammount: NSAttributedString
    public var status: TransactionStatus
    public var type: TransactionType
    public var date: TimeInterval
    
    public var stringDate: String {
        let txDate = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter(formate: DateFormat.dayMonth)
        return dateFormatter.string(from: txDate)
    }
    
    public init(hash: String, address: String, ammount: NSAttributedString, status: TransactionStatus, type: TransactionType, date: TimeInterval) {
        self.hash = hash
        self.address = address
        self.ammount = ammount
        self.status = status
        self.type = type
        self.date = date
    }
}
