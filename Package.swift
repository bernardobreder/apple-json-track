//
//  Package.swift
//  JsonTrack
//
//

import PackageDescription

let package = Package(
	name: "JsonTrack",
	targets: [
		Target(name: "JsonTrack", dependencies: ["Json"]),
		Target(name: "Array", dependencies: []),
		Target(name: "IndexLiteral", dependencies: []),
		Target(name: "Json", dependencies: ["Array", "IndexLiteral", "Literal"]),
		Target(name: "Literal", dependencies: []),
	]
)

