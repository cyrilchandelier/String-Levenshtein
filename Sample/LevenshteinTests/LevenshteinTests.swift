//
//  LevenshteinTests.swift
//  LevenshteinTests
//
//  Created by Cyril Chandelier on 01/07/15.
//  Copyright (c) 2015 Cyril Chandelier. All rights reserved.
//

import UIKit
import XCTest

/**
 These tests were found in the following blog post and translated to this Swift implementation :
 http://oldfashionedsoftware.com/2009/11/19/string-distance-and-refactoring-in-scala/
 */
class LevenshteinTests: XCTestCase {
    
    func testThatDistanceWorksOnEmptyStrings() {
        XCTAssertEqual("".levenshteinDistance(with: ""), 0)
        XCTAssertEqual("".levenshteinDistance(with: "a"), 1)
        XCTAssertEqual("".levenshteinDistance(with: "abc"), 3)
        XCTAssertEqual("a".levenshteinDistance(with: ""), 1)
        XCTAssertEqual("abc".levenshteinDistance(with: ""), 3)
    }
    
    func testThatDistanceWorksOnEqualStrings() {
        XCTAssertEqual("".levenshteinDistance(with: ""), 0)
        XCTAssertEqual("a".levenshteinDistance(with: "a"), 0)
        XCTAssertEqual("abc".levenshteinDistance(with: "abc"), 0)
    }
    
    func testThatDistanceWorksWhereOnlyInsertsAreNeeded() {
        XCTAssertEqual("".levenshteinDistance(with: "a"), 1)
        XCTAssertEqual("a".levenshteinDistance(with: "ab"), 1)
        XCTAssertEqual("b".levenshteinDistance(with: "ab"), 1)
        XCTAssertEqual("ac".levenshteinDistance(with: "abc"), 1)
        XCTAssertEqual("abcdefg".levenshteinDistance(with: "xaxbxcxdxexfxgx"), 8)
    }
    
    func testThatDistanceWorksWhereOnlyDeletesAreNeeded() {
        XCTAssertEqual("a".levenshteinDistance(with: ""), 1)
        XCTAssertEqual("ab".levenshteinDistance(with: "a"), 1)
        XCTAssertEqual("ab".levenshteinDistance(with: "b"), 1)
        XCTAssertEqual("abc".levenshteinDistance(with: "ac"), 1)
        XCTAssertEqual("xaxbxcxdxexfxgx".levenshteinDistance(with: "abcdefg"), 8)
    }
    
    func testThatDistanceWorksWhereOnlySubsistutionsAreNeeded() {
        XCTAssertEqual("a".levenshteinDistance(with: "b"), 1)
        XCTAssertEqual("ab".levenshteinDistance(with: "ac"), 1)
        XCTAssertEqual("ac".levenshteinDistance(with: "bc"), 1)
        XCTAssertEqual("abc".levenshteinDistance(with: "axc"), 1)
        XCTAssertEqual("xaxbxcxdxexfxgx".levenshteinDistance(with: "1a2b3c4d5e6f7g8"), 8)
    }
    
    func testThatDistanceWorksWhereManyOperationsAreNeeded() {
        XCTAssertEqual("example".levenshteinDistance(with: "samples"), 3)
        XCTAssertEqual("sturgeon".levenshteinDistance(with: "urgently"), 6)
        XCTAssertEqual("levenshtein".levenshteinDistance(with: "frankenstein"), 6)
        XCTAssertEqual("distance".levenshteinDistance(with: "difference"), 5)
        XCTAssertEqual("objc was neat".levenshteinDistance(with: "swift is great"), 9)
    }
    
}
