//
//  String.swift
//  FrameStepper
//
//  Created by Kazuya Shida on 2017/11/23.
//  Copyright © 2017 mani3. All rights reserved.
//

import Foundation

extension String {

    var urlEncode: String {
        let mutable = NSMutableCharacterSet()
        mutable.addCharacters(in: "*-._ ")
        mutable.formUnion(with: .alphanumerics)
        let encoded = addingPercentEncoding(withAllowedCharacters: mutable as CharacterSet) ?? self
        return encoded.replacingOccurrences(of: " ", with: "+")
    }

    var urlDecode: String {
        let url = replacingOccurrences(of: "+", with: "%2B")
        let decoded = (url as NSString).removingPercentEncoding ?? self
        return decoded
    }

}
