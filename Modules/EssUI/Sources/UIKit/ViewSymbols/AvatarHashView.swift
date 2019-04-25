//
//  AvatarHashView.swift
//  EssUI
//
//  Created by Pavlo Boiko on 4/15/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import CommonCrypto
import UIKit

fileprivate extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: 1.0)
    }
    
    convenience init(hex: String) {
        self.init(rgb: Int(hex, radix: 16) ?? 1)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

fileprivate extension Data {
    var sha256: Data {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        self.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(self.count), &hash)
        }
        return Data(hash)
    }
    
    var hex: String {
        return reduce("") {$0 + String(format: "%02x", $1)}
    }
}

public var AVATAR_DEFAULT_BLOKS_COUNT: UInt8 = 10

public class AvatarHashView: UIView {
    private var blockPerSide: UInt8
    private var value: Data
    
    // MARK: - Init
    public init(hash: String, frame: CGRect, blocksPerSide: UInt8 = AVATAR_DEFAULT_BLOKS_COUNT) {
        self.value = Data(hash.utf8).sha256
        self.blockPerSide = blocksPerSide
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.value = Data([UInt8(arc4random() % UInt32(UInt8.max))]).sha256
        self.blockPerSide = AVATAR_DEFAULT_BLOKS_COUNT
        super.init(coder: aDecoder)
    }
    
    // MARK: - Public
    public func setUser(hash: String, blocksCount: UInt8 = AVATAR_DEFAULT_BLOKS_COUNT) {
        self.value = Data(hash.utf8).sha256
        setNeedsDisplay()
    }
    
    public var image: UIImage {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        return renderer.image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }
    
    override public func draw(_ rect: CGRect) {
        let valueHex = value.hex
        let hexCount = valueHex.count
        let itemsToCut = hexCount - 6
        guard itemsToCut > 0 else { return }
        let background =  UIColor(hex: String(valueHex.dropFirst(itemsToCut)))
        let fill = UIColor(hex: String(valueHex.dropLast(itemsToCut)))
        let oneBlockSize = CGSize(width: rect.size.width / CGFloat(blockPerSide),
                                  height: rect.size.height / CGFloat(blockPerSide))
        
        let backgroudPath = UIBezierPath(rect: rect)
        background.setFill()
        backgroudPath.fill()
        
        let halfOneSideBlocksCount = Int(ceil(Double(blockPerSide) / 2.0))
        let halfAllBlocsCount = halfOneSideBlocksCount * Int(blockPerSide)
        let isEverBlockCount = blockPerSide % 2 == 0
        let negativeBlocksAddition = isEverBlockCount ? 1 : 0
        
        for i in 0..<halfAllBlocsCount {
            let advanceValueBytes = Data("\(i)".utf8)
            let currentFullBytes = value + advanceValueBytes
            let currentBlockData = currentFullBytes.sha256.hex.prefix(5)
            let calculateBlockValue = currentBlockData.reduce(0, { return $0 + UInt64(Data("\($1)".utf8)[0]) })
            let currentValue = calculateBlockValue % 2 == 0
            if currentValue {
                let x = ((i % halfOneSideBlocksCount))
                let y = (i / halfOneSideBlocksCount)
                drawBlock(x: x, y: y, blockSize: oneBlockSize, color: fill)
                drawBlock(x: -(x + negativeBlocksAddition), y: y, blockSize: oneBlockSize, color: fill)
            }
        }
    }
    
    // MARK: - Private
    private func drawBlock(x: Int, y: Int, blockSize: CGSize, color: UIColor) {
        let halfWidthBlockCount = blockPerSide / 2
        let halfWidth = blockSize.width * CGFloat(halfWidthBlockCount)
        let point = CGPoint(x: (CGFloat(x) * blockSize.width) + halfWidth ,
                            y: CGFloat(y) * blockSize.height)
        let path = UIBezierPath(rect: CGRect(origin: point, size: blockSize))
        color.setFill()
        path.fill()
    }
}
