//
//  String+Levenshtein.swift
//  Levenshtein
//
//  Created by Cyril Chandelier on 01/07/15.
//  Copyright (c) 2015 Cyril Chandelier. All rights reserved.
//

import Foundation

extension String
{
    /**
    Inner class representing a two dimension array with subscript access to contained values
    */
    private class Array2D
    {
        var rows: Int
        var columns: Int
        var matrix: [Int]
        
        init(rows: Int, columns: Int)
        {
            self.rows = rows
            self.columns = columns
            self.matrix = Array(count:rows * columns, repeatedValue:0)
        }
                
        subscript(row: Int, column: Int) -> Int {
            get {
                return matrix[row * columns + column]
            }
            set {
                matrix[row * columns + column] = newValue
            }
        }
    }
    
    /**
    Compute levenshtein distance between self and given String objects
    
    - parameter anotherString: A String object to compute the distance with
    - parameter caseSensitive: Weither or not the comparison should be case sensiste
    
    - returns: An Int representing levenshtein distance, the higher this number is, the more words are distant
    */
    func levenshtein(anotherString: String, caseSensitive: Bool = true) -> Int
    {
        // Early exits for empty strings
        if self.characters.count == 0 {
            return anotherString.characters.count
        }
        if (anotherString.characters.count == 0) {
            return self.characters.count
        }
        
        // Create arrays from strings
        let a = Array(caseSensitive ? self.utf16 : self.lowercaseString.utf16)
        let b = Array(caseSensitive ? anotherString.utf16 : anotherString.lowercaseString.utf16)
        
        // Initialize a 2D array for scores
        let scores = Array2D(rows: a.count + 1, columns: b.count + 1)
        
        // Fill scores of first word
        for i in 1...a.count
        {
            scores[i, 0] = i
        }
        
        // Fill scores of second word
        for j in 1...b.count
        {
            scores[0, j] = j
        }
        
        // Compute scores
        for i in 1...a.count
        {
            for j in 1...b.count
            {
                let cost: Int = a[i - 1] == b[j - 1] ? 0 : 1
                scores[i, j] = min(
                    scores[i - 1, j    ] + 1,   // deletion
                    scores[i    , j - 1] + 1,   // insertion
                    scores[i - 1, j - 1] + cost // substitution
                )
                
            }
        }
        
        return scores[a.count, b.count]
    }
}