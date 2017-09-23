//
//  JsonTrackTests.swift
//  JsonTrack
//
//  Created by Bernardo Breder.
//
//

import XCTest
@testable import JsonTrackTests

extension JsonTrackTests {

	static var allTests : [(String, (JsonTrackTests) -> () throws -> Void)] {
		return [
			("testApplyMultipleChangeTrack", testApplyMultipleChangeTrack),
			("testDeleteChangeTrack", testDeleteChangeTrack),
			("testDeleteChangeTrackToEmpty", testDeleteChangeTrackToEmpty),
			("testInsertArrayChangeTrackEmpty", testInsertArrayChangeTrackEmpty),
			("testInsertChangeTrackFilled", testInsertChangeTrackFilled),
			("testInsertDicChangeTrackEmpty", testInsertDicChangeTrackEmpty),
			("testMultipleTimesChangeTrack", testMultipleTimesChangeTrack),
			("testPathInt", testPathInt),
			("testPaths", testPaths),
			("testPathString", testPathString),
			("testRevertMultipleChangeTrack", testRevertMultipleChangeTrack),
			("testRevertTwoChangeTrack", testRevertTwoChangeTrack),
			("testUpdateChangeTrack", testUpdateChangeTrack),
		]
	}

}

extension JsonTrackChangeTests {

	static var allTests : [(String, (JsonTrackChangeTests) -> () throws -> Void)] {
		return [
			("testExample", testExample),
		]
	}

}

XCTMain([
	testCase(JsonTrackTests.allTests),
	testCase(JsonTrackChangeTests.allTests),
])

