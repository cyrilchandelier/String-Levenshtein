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
class LevenshteinTests: XCTestCase
{
    func testThatDistanceWorksOnEmptyStrings()
    {
        XCTAssertEqual("".levenshtein(""), 0)
        XCTAssertEqual("".levenshtein("a"), 1)
        XCTAssertEqual("".levenshtein("abc"), 3)
        XCTAssertEqual("a".levenshtein(""), 1)
        XCTAssertEqual("abc".levenshtein(""), 3)
    }
    
    func testThatDistanceWorksOnEqualStrings()
    {
        XCTAssertEqual("".levenshtein(""), 0)
        XCTAssertEqual("a".levenshtein("a"), 0)
        XCTAssertEqual("abc".levenshtein("abc"), 0)
    }
    
    func testThatDistanceWorksWhereOnlyInsertsAreNeeded()
    {
        XCTAssertEqual("".levenshtein("a"), 1)
        XCTAssertEqual("a".levenshtein("ab"), 1)
        XCTAssertEqual("b".levenshtein("ab"), 1)
        XCTAssertEqual("ac".levenshtein("abc"), 1)
        XCTAssertEqual("abcdefg".levenshtein("xaxbxcxdxexfxgx"), 8)
    }
    
    func testThatDistanceWorksWhereOnlyDeletesAreNeeded()
    {
        XCTAssertEqual("a".levenshtein(""), 1)
        XCTAssertEqual("ab".levenshtein("a"), 1)
        XCTAssertEqual("ab".levenshtein("b"), 1)
        XCTAssertEqual("abc".levenshtein("ac"), 1)
        XCTAssertEqual("xaxbxcxdxexfxgx".levenshtein("abcdefg"), 8)
    }
    
    func testThatDistanceWorksWhereOnlySubsistutionsAreNeeded()
    {
        XCTAssertEqual("a".levenshtein("b"), 1)
        XCTAssertEqual("ab".levenshtein("ac"), 1)
        XCTAssertEqual("ac".levenshtein("bc"), 1)
        XCTAssertEqual("abc".levenshtein("axc"), 1)
        XCTAssertEqual("xaxbxcxdxexfxgx".levenshtein("1a2b3c4d5e6f7g8"), 8)
    }
    
    func testThatDistanceWorksWhereManyOperationsAreNeeded()
    {
        XCTAssertEqual("example".levenshtein("samples"), 3)
        XCTAssertEqual("sturgeon".levenshtein("urgently"), 6)
        XCTAssertEqual("levenshtein".levenshtein("frankenstein"), 6)
        XCTAssertEqual("distance".levenshtein("difference"), 5)
        XCTAssertEqual("objc was neat".levenshtein("swift is great"), 9)
    }
}
