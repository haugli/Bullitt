//
//  String+MD5.swift
//  Bullitt
//
//  Copyright (c) 2015 Chris Haugli. All rights reserved.
//

import CryptoSwift

extension String {
    func MD5() -> String {
        let data = (self as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
        let hashData = CryptoSwift.Hash.md5(data).calculate()!
        
        return hashData.toHexString()
    }
}
