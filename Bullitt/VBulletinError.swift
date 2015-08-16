//
//  VBulletinError.swift
//  Bullitt
//
//  Copyright (c) 2015 Chris Haugli. All rights reserved.
//

import Foundation

public enum VBulletinError: Int {
    
    public static let domain = "com.chrishaugli.bullitt.vbulletin"
    
    /**
    Indicates that an unexpected response occurred in the API initialization network call.
    */
    case APIInitializationFailure = 100
}
