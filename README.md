# String+Levenshtein.swift
A Swift extension on String to compute Levenshtein distance between words.

## Installation
Copy the `String+Levenshtein.swift` file into your project.

## Usage

To retrieve the Levenshtein distance between two words, simply call the `levenshteinDistance` method on one word with the other.

Example:
```
let firstWord: String = "Hello"
let secondWord: String = "Help"
let levenshteinDistance: Int = firstWord.levenshteinDistance(with: secondWord)
print(levenshteinDistance) // Prints "2"
```


## Sample
Have a look to the sample project to see how this extension can be use to display a "Did you mean?" hint to users in search results.
