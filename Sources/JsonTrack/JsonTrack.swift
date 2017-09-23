//
//  JsonTrack.swift
//  JsonTrack
//
//  Created by Bernardo Breder on 27/01/17.
//
//

import Foundation
#if SWIFT_PACKAGE
import Literal
import IndexLiteral
import Json
#endif

public class JsonTrack {
    
    public let json: Json
    
    public internal(set) var changes: [JsonTrackChange] = []
    
    public init(json: Json) {
        self.json = json
    }
    
    @discardableResult
    public func apply(_ paths: [IndexLiteral], value: Literal) -> Self {
        let from = json[paths], to = Json(value); json[paths] = to
        changes.append(JsonTrackChange(paths: paths, from: from, to: to).apply(json: json))
        return self
    }
    
    @discardableResult
    public func applyArray(_ paths: [IndexLiteral]) -> Self {
        let from = json[paths], to = Json([]); json[paths] = to
        changes.append(JsonTrackChange(paths: paths, from: from, to: to).apply(json: json))
        return self
    }
    
    @discardableResult
    public func applyDictionary(_ paths: [IndexLiteral]) -> Self {
        let from = json[paths], to = Json([:]); json[paths] = to
        changes.append(JsonTrackChange(paths: paths, from: from, to: to).apply(json: json))
        return self
    }
    
}
