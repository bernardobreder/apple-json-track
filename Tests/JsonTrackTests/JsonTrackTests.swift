//
//  JsonTrack.swift
//  JsonTrack
//
//  Created by Bernardo Breder on 27/01/17.
//
//

import XCTest
@testable import Literal
@testable import Json
@testable import JsonTrack

class JsonTrackTests: XCTestCase {

	func testPaths() throws {
        let json = Json([:])
        let track = JsonTrack(json: json)
        
        track.apply(["a", "b", "c"], value: 1)
        XCTAssertEqual(1, track.changes.count)
        XCTAssertEqual(1, json[["a", "b", "c"]].int)
        
        track.apply(["a", "b", "d", "e", "f"], value: 2)
        XCTAssertEqual(2, track.changes.count)
        XCTAssertEqual(1, json[["a", "b", "c"]].int)
        XCTAssertEqual(2, json[["a", "b", "d", "e", "f"]].int)
        
        track.apply(["b"], value: 3)
        XCTAssertEqual(3, track.changes.count)
        XCTAssertEqual(1, json[["a", "b", "c"]].int)
        XCTAssertEqual(2, json[["a", "b", "d", "e", "f"]].int)
        XCTAssertEqual(3, json[["b"]].int)
        
        track.apply(["c", 0, "d"], value: 4)
        XCTAssertEqual(4, track.changes.count)
        XCTAssertEqual(1, json[["a", "b", "c"]].int)
        XCTAssertEqual(2, json[["a", "b", "d", "e", "f"]].int)
        XCTAssertEqual(3, json[["b"]].int)
        XCTAssertEqual(4, json[["c", 0, "d"]].int)
        
        track.changes.removeLast().revert(json: json)
        XCTAssertEqual(3, track.changes.count)
        XCTAssertEqual(1, json[["a", "b", "c"]].int)
        XCTAssertEqual(2, json[["a", "b", "d", "e", "f"]].int)
        XCTAssertEqual(3, json[["b"]].int)
        XCTAssertNil(json[["c", 0, "d"]].int)
        
        track.changes.removeLast().revert(json: json)
        XCTAssertEqual(2, track.changes.count)
        XCTAssertEqual(1, json[["a", "b", "c"]].int)
        XCTAssertEqual(2, json[["a", "b", "d", "e", "f"]].int)
        XCTAssertNil(json[["b"]].int)
        XCTAssertNil(json[["c", 0, "d"]].int)
        
        track.changes.removeLast().revert(json: json)
        XCTAssertEqual(1, track.changes.count)
        XCTAssertEqual(1, json[["a", "b", "c"]].int)
        XCTAssertNil(json[["a", "b", "d", "e", "f"]].int)
        XCTAssertNil(json[["b"]].int)
        XCTAssertNil(json[["c", 0, "d"]].int)
        
        track.changes.removeLast().revert(json: json)
        XCTAssertEqual(0, track.changes.count)
        XCTAssertNil(json[["a", "b", "c"]].int)
        XCTAssertNil(json[["a", "b", "d", "e", "f"]].int)
        XCTAssertNil(json[["b"]].int)
        XCTAssertNil(json[["c", 0, "d"]].int)
        
        XCTAssertEqual(Json([:]), json.clearNil())
	}
    
    func testPathString() throws {
        let json = Json([:])
        let track = JsonTrack(json: json)
        
        track.apply(["a"], value: 1)
        XCTAssertEqual(1, track.changes.count)
        XCTAssertEqual(1, json[["a"]].int)
        
        track.apply(["a"], value: 2)
        XCTAssertEqual(2, track.changes.count)
        XCTAssertEqual(2, json[["a"]].int)
        
        track.apply(["a"], value: 3)
        XCTAssertEqual(3, track.changes.count)
        XCTAssertEqual(3, json[["a"]].int)
        
        track.changes.removeLast().revert(json: json)
        XCTAssertEqual(2, track.changes.count)
        XCTAssertEqual(2, json[["a"]].int)
        
        track.changes.removeLast().revert(json: json)
        XCTAssertEqual(1, track.changes.count)
        XCTAssertEqual(1, json[["a"]].int)
        
        track.changes.removeLast().revert(json: json)
        XCTAssertEqual(0, track.changes.count)
        XCTAssertNil(json[["a"]].int)
    }

    func testPathInt() throws {
        let json = Json([:])
        let track = JsonTrack(json: json)
        
        track.apply([0], value: 1)
        XCTAssertEqual(1, track.changes.count)
        XCTAssertEqual(1, json[[0]].int)
        
        track.apply([0], value: 2)
        XCTAssertEqual(2, track.changes.count)
        XCTAssertEqual(2, json[[0]].int)
        
        track.apply([0], value: 3)
        XCTAssertEqual(3, track.changes.count)
        XCTAssertEqual(3, json[[0]].int)
        
        track.changes.removeLast().revert(json: json)
        XCTAssertEqual(2, track.changes.count)
        XCTAssertEqual(2, json[[0]].int)
        
        track.changes.removeLast().revert(json: json)
        XCTAssertEqual(1, track.changes.count)
        XCTAssertEqual(1, json[[0]].int)
        
        track.changes.removeLast().revert(json: json)
        XCTAssertEqual(0, track.changes.count)
        XCTAssertNil(json[[0]].int)
    }
    
    func testInsertDicChangeTrackEmpty() throws {
        let json = Json([:])
        let change = JsonTrackChange(paths: ["a", "b", "c"], from: Json(), to: Json("abc"))
        change.apply(json: json)
        XCTAssertEqual("abc", json["a"]["b"]["c"].string)
        change.revert(json: json)
        json.clearNil().array({ array in if array.empty { _ = json.dicOrSet } })
        XCTAssertNil(json["a"]["b"]["c"].string)
        XCTAssertEqual(try Json([:]).jsonToString(), try json.jsonToString())
    }
    
    func testInsertArrayChangeTrackEmpty() throws {
        do {
            let json = Json([:])
            let change = JsonTrackChange(paths: [0], from: Json(), to: Json("abc"))
            change.apply(json: json)
            XCTAssertEqual("abc", json[0].string)
            change.revert(json: json)
            json.clearNil().array({ array in if array.empty { _ = json.dicOrSet } })
            XCTAssertNil(json[0].string)
            XCTAssertEqual(try Json([:]).jsonToString(), try json.jsonToString())
        }
        do {
            let json = Json([:])
            let change = JsonTrackChange(paths: [0, 0], from: Json(), to: Json("abc"))
            change.apply(json: json)
            XCTAssertEqual("abc", json[0][0].string)
            change.revert(json: json)
            json.clearNil().array({ array in if array.empty { _ = json.dicOrSet } })
            XCTAssertNil(json[0][0].string)
            XCTAssertEqual(try Json([:]).jsonToString(), try json.jsonToString())
        }
        do {
            let json = Json([:])
            let change = JsonTrackChange(paths: [0, "a"], from: Json(), to: Json("abc"))
            change.apply(json: json)
            XCTAssertEqual("abc", json[0]["a"].string)
            change.revert(json: json)
            json.clearNil().array({ array in if array.empty { _ = json.dicOrSet } })
            XCTAssertNil(json[0]["a"].string)
            XCTAssertEqual(try Json([:]).jsonToString(), try json.jsonToString())
        }
        do {
            let json = Json([:])
            let change = JsonTrackChange(paths: [0, 0, "a"], from: Json(), to: Json("abc"))
            change.apply(json: json)
            XCTAssertEqual("abc", json[0][0]["a"].string)
            change.revert(json: json)
            json.clearNil().array({ array in if array.empty { _ = json.dicOrSet } })
            XCTAssertNil(json[0][0]["a"].string)
            XCTAssertEqual(try Json([:]).jsonToString(), try json.jsonToString())
        }
        do {
            let json = Json([:])
            let change = JsonTrackChange(paths: ["a", 0, 1, "b"], from: Json(), to: Json("abc"))
            change.apply(json: json)
            XCTAssertEqual("abc", json["a"][0][1]["b"].string)
            change.revert(json: json)
            json.clearNil().array({ array in if array.empty { _ = json.dicOrSet } })
            XCTAssertNil(json["a"][0][1]["b"].string)
            XCTAssertEqual(try Json([:]).jsonToString(), try json.jsonToString())
        }
        do {
            let json = Json([:])
            let change = JsonTrackChange(paths: ["a", 0, "c"], from: Json(), to: Json("abc"))
            change.apply(json: json)
            XCTAssertEqual("abc", json["a"][0]["c"].string)
            change.revert(json: json)
            json.clearNil().array({ array in if array.empty { _ = json.dicOrSet } })
            XCTAssertNil(json["a"][0]["c"].string)
            XCTAssertEqual(try Json([:]).jsonToString(), try json.jsonToString())
        }
    }
    
    func testInsertChangeTrackFilled() throws {
        let json = try Json(["d": "e"])
        let change = JsonTrackChange(paths: ["a", "b", "c"], from: Json(), to: Json("abc"))
        change.apply(json: json)
        XCTAssertEqual("abc", json["a"]["b"]["c"].string)
        change.revert(json: json)
        json.clearNil().array({ array in if array.empty { _ = json.dicOrSet } })
        XCTAssertNil(json["a"]["b"]["c"].string)
        XCTAssertEqual(try Json(["d": "e"]).jsonToString(), try json.jsonToString())
    }
    
    func testUpdateChangeTrack() throws {
        let json = try Json(["a": "b"])
        let change = JsonTrackChange(paths: ["a"], from: Json("b"), to: Json("c"))
        change.apply(json: json)
        XCTAssertEqual("c", json["a"].string)
        XCTAssertEqual(try Json(["a": "c"]).jsonToString(), try json.jsonToString())
        change.revert(json: json)
        XCTAssertEqual("b", json["a"].string)
        XCTAssertEqual(try Json(["a": "b"]).jsonToString(), try json.jsonToString())
    }
    
    func testDeleteChangeTrackToEmpty() throws {
        let json = try Json(["a": "b"])
        let change = JsonTrackChange(paths: ["a"], from: "b", to: Json())
        change.apply(json: json)
        XCTAssertNil(json["a"].string)
        XCTAssertEqual(try Json([:]).jsonToString(), try json.jsonToString())
        change.revert(json: json)
        XCTAssertEqual("b", json["a"].string)
        XCTAssertEqual(try Json(["a": "b"]).jsonToString(), try json.jsonToString())
    }
    
    func testDeleteChangeTrack() throws {
        let json = try Json(["a": "b", "c": "d"])
        let change = JsonTrackChange(paths: ["a"], from: Json("b"), to: Json())
        change.apply(json: json)
        XCTAssertNil(json["a"].string)
        XCTAssertEqual("d", json["c"].string)
        XCTAssertEqual(try Json(["c": "d"]).jsonToString(), try json.jsonToString())
        change.revert(json: json)
        XCTAssertEqual("b", json["a"].string)
        XCTAssertEqual("d", json["c"].string)
        XCTAssertEqual(try Json(["c": "d", "a": "b"]).jsonToString(), try json.jsonToString())
    }
    
    func testApplyMultipleChangeTrack() throws {
        let json = Json([:])
        let changes = [
            JsonTrackChange(paths: ["a", "b", "c"], from: Json(), to: Json("abc")),
            JsonTrackChange(paths: ["a", "d", "e"], from: Json(), to: Json("cba")),
            JsonTrackChange(paths: ["f", "g", "h"], from: Json(), to: Json("123")),
            JsonTrackChange(paths: ["a", "i", "j"], from: Json(), to: Json("321")),
            JsonTrackChange(paths: ["a", "b", "c"], from: Json("abc"), to: Json("ABC")),
            JsonTrackChange(paths: ["a", "d", "e"], from: Json("cba"), to: Json("CBA")),
            JsonTrackChange(paths: ["f", "g", "h"], from: Json("123"), to: Json()),
            JsonTrackChange(paths: ["a", "i", "j"], from: Json("321"), to: Json())
        ]
        for change in changes { change.apply(json: json) }
        json.clearNil().array({ array in if array.empty { _ = json.dicOrSet } })
        let expected = Json([:])
        expected["a"] = [:]
        expected["a"]["b"] = [:]
        expected["a"]["b"]["c"] = "ABC"
        expected["a"]["d"] = [:]
        expected["a"]["d"]["e"] = "CBA"
        XCTAssertEqual(try expected.jsonToString(), try json.jsonToString())
        for change in changes.reversed() { change.revert(json: json) }
        json.clearNil().array({ array in if array.empty { _ = json.dicOrSet } })
        XCTAssertEqual(try Json([:]).jsonToString(), try json.jsonToString())
    }
    
    func testRevertTwoChangeTrack() throws {
        let json = Json([:])
        let changes = [
            JsonTrackChange(paths: ["a", "b", "c"], from: Json(), to: Json("abc")),
            JsonTrackChange(paths: ["b", 0, "z"], from: Json(), to: Json("111")),
            ]
        for change in changes { change.apply(json: json) }
        do {
            let expected = Json([:])
            expected["a"] = [:]
            expected["a"]["b"] = [:]
            expected["a"]["b"]["c"] = "abc"
            expected["b"] = []
            expected["b"][0] = [:]
            expected["b"][0]["z"] = "111"
            XCTAssertEqual(try expected.jsonToString(), try json.jsonToString())
        }
        for change in changes.reversed() { change.revert(json: json) }
        json.clearNil().array({ array in if array.empty { _ = json.dicOrSet } })
        XCTAssertEqual(try Json([:]).jsonToString(), try json.jsonToString())
    }
    
    func testRevertMultipleChangeTrack() throws {
        let json = Json([:])
        let changes = [
            JsonTrackChange(paths: ["a", "b", "c"], from: Json(), to: Json("abc")),
            JsonTrackChange(paths: ["a", "d", "e"], from: Json(), to: Json("cba")),
            JsonTrackChange(paths: ["f", "g", "h"], from: Json(), to: Json("123")),
            JsonTrackChange(paths: ["a", "i", "j"], from: Json(), to: Json("321")),
            JsonTrackChange(paths: ["b", 0, "z"], from: Json(), to: Json("111")),
            ]
        for change in changes { change.apply(json: json) }
        do {
            let expected = Json([:])
            expected["a"] = [:]
            expected["a"]["b"] = [:]
            expected["a"]["b"]["c"] = "abc"
            expected["a"]["d"] = [:]
            expected["a"]["d"]["e"] = "cba"
            expected["f"] = [:]
            expected["f"]["g"] = [:]
            expected["f"]["g"]["h"] = "123"
            expected["a"]["i"] = [:]
            expected["a"]["i"]["j"] = "321"
            expected["b"] = []
            expected["b"][0] = [:]
            expected["b"][0]["z"] = "111"
            XCTAssertEqual(try expected.jsonToString(), try json.jsonToString())
        }
        for change in changes.reversed() { change.revert(json: json) }
        json.clearNil().array({ array in if array.empty { _ = json.dicOrSet } })
        XCTAssertEqual(try Json([:]).jsonToString(), try json.jsonToString())
    }
    
    func testMultipleTimesChangeTrack() throws {
        let change1 = [
            JsonTrackChange(paths: ["a", "b", "c"], from: Json(), to: Json("abc")),
            JsonTrackChange(paths: ["a", "d", "e"], from: Json(), to: Json("cba")),
            ]
        let change2 = [
            JsonTrackChange(paths: ["a", "b", "c"], from: Json("abc"), to: Json("ABC")),
            JsonTrackChange(paths: ["a", "d", "e"], from: Json("cba"), to: Json("CBA")),
            ]
        let change3 = [
            JsonTrackChange(paths: ["f", "g", "h"], from: Json(), to: Json("123")),
            JsonTrackChange(paths: ["a", "i", "j"], from: Json(), to: Json("321")),
            ]
        let change4 = [
            JsonTrackChange(paths: ["f", "g", "h"], from: Json("123"), to: Json()),
            JsonTrackChange(paths: ["a", "i", "j"], from: Json("321"), to: Json())
        ]
        let json = Json([:])
        for change in change1 { change.apply(json: json) }
        do {
            let expected = Json([:])
            expected["a"] = [:]
            expected["a"]["b"] = [:]
            expected["a"]["b"]["c"] = "abc"
            expected["a"]["d"] = [:]
            expected["a"]["d"]["e"] = "cba"
            XCTAssertEqual(try expected.jsonToString(), try json.jsonToString())
        }
        for change in change2 { change.apply(json: json) }
        do {
            let expected = Json([:])
            expected["a"] = [:]
            expected["a"]["b"] = [:]
            expected["a"]["b"]["c"] = "ABC"
            expected["a"]["d"] = [:]
            expected["a"]["d"]["e"] = "CBA"
            XCTAssertEqual(try expected.jsonToString(), try json.jsonToString())
        }
        for change in change3 { change.apply(json: json) }
        do {
            let expected = Json([:])
            expected["a"] = [:]
            expected["a"]["b"] = [:]
            expected["a"]["b"]["c"] = "ABC"
            expected["a"]["d"] = [:]
            expected["a"]["d"]["e"] = "CBA"
            expected["f"] = [:]
            expected["f"]["g"] = [:]
            expected["f"]["g"]["h"] = "123"
            expected["a"]["i"] = [:]
            expected["a"]["i"]["j"] = "321"
            XCTAssertEqual(try expected.jsonToString(), try json.jsonToString())
        }
        for change in change4 { change.apply(json: json) }
        json.clearNil().array({ array in if array.empty { _ = json.dicOrSet } })
        do {
            let expected = Json([:])
            expected["a"] = [:]
            expected["a"]["b"] = [:]
            expected["a"]["b"]["c"] = "ABC"
            expected["a"]["d"] = [:]
            expected["a"]["d"]["e"] = "CBA"
            XCTAssertEqual(try expected.jsonToString(), try json.jsonToString())
        }
        for change in change4.reversed() { change.revert(json: json) }
        json.clearNil().array({ array in if array.empty { _ = json.dicOrSet } })
        do {
            let expected = Json([:])
            expected["a"] = [:]
            expected["a"]["b"] = [:]
            expected["a"]["b"]["c"] = "ABC"
            expected["a"]["d"] = [:]
            expected["a"]["d"]["e"] = "CBA"
            expected["f"] = [:]
            expected["f"]["g"] = [:]
            expected["f"]["g"]["h"] = "123"
            expected["a"]["i"] = [:]
            expected["a"]["i"]["j"] = "321"
            XCTAssertEqual(try expected.jsonToString(), try json.jsonToString())
        }
        for change in change3.reversed() { change.revert(json: json) }
        json.clearNil().array({ array in if array.empty { _ = json.dicOrSet } })
        do {
            let expected = Json([:])
            expected["a"] = [:]
            expected["a"]["b"] = [:]
            expected["a"]["b"]["c"] = "ABC"
            expected["a"]["d"] = [:]
            expected["a"]["d"]["e"] = "CBA"
            XCTAssertEqual(try expected.jsonToString(), try json.jsonToString())
        }
        for change in change2.reversed() { change.revert(json: json) }
        json.clearNil().array({ array in if array.empty { _ = json.dicOrSet } })
        do {
            let expected = Json([:])
            expected["a"] = [:]
            expected["a"]["b"] = [:]
            expected["a"]["b"]["c"] = "abc"
            expected["a"]["d"] = [:]
            expected["a"]["d"]["e"] = "cba"
            XCTAssertEqual(try expected.jsonToString(), try json.jsonToString())
        }
        for change in change1.reversed() { change.revert(json: json) }
        json.clearNil().array({ array in if array.empty { _ = json.dicOrSet } })
        XCTAssertEqual(try Json([:]).jsonToString(), try json.jsonToString())
    }

}

