//
//  JsonChange.swift
//  JsonTrack
//
//  Created by Bernardo Breder on 28/01/17.
//
//

import Foundation
#if SWIFT_PACKAGE
import Literal
import IndexLiteral
import Json
#endif

public struct JsonTrackChange {
    
    public let paths: [IndexLiteral]
    
    public let from: Json
    
    public let to: Json
    
    @discardableResult
    public func apply(json: Json) -> JsonTrackChange {
        json[paths] = to
        return self
    }
    
    @discardableResult
    public func revert(json: Json) -> JsonTrackChange {
        json[paths] = from
        return self
    }
    
}
