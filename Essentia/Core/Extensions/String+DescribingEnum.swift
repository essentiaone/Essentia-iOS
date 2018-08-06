//
//  String+DescribingEnum.swift
//  Essentia
//
//  Created by Pavlo Boiko on 04.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

extension String {
    var describedEnum: String {
        guard let breacketIndex = self.index(of: "(") else {
            return self
        }
        return String(self.prefix(upTo: breacketIndex))
    }
}
