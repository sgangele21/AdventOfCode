import UIKit
import XCPlayground
import PlaygroundSupport

struct Rucksack {
    
    let wholeRucksack: String
    
    var firstComponent: String {
        let startIndex = wholeRucksack.startIndex
        let endIndex = wholeRucksack.index(startIndex, offsetBy: wholeRucksack.count / 2)
        return String(Array(wholeRucksack[startIndex..<endIndex]))
    }
    
    var lastComponent: String {
        let startIndex = wholeRucksack.index(wholeRucksack.startIndex, offsetBy: wholeRucksack.count / 2)
        let endIndex = wholeRucksack.endIndex
        return String(Array(wholeRucksack[startIndex..<endIndex]))
    }
    
}

struct Matcher {
    
    let rucksack: Rucksack
    
    func findSharedItems() -> [String] {
        var set = Set<String>()
        var sharedItems = Set<String>()
        rucksack.firstComponent.forEach { set.insert(String($0)) }
        rucksack.lastComponent.forEach { if set.contains(String($0)) { sharedItems.insert(String($0)) } }
        return Array(sharedItems)
    }
    
}

struct GroupMatcher {
    
    let rucksacks: [Rucksack]
    
    func findSharedItem() -> String {
        var dict: [String: Int] = [:]
        for rucksack in rucksacks {
            for item in Set(Array(rucksack.wholeRucksack)) { // DAAAAAMN BRO THIS WAS THE KEY!!!!!
                let strItem = String(item)
                dict[strItem] = (dict[strItem] ?? 0) + 1
                if dict[strItem] == 3 { return strItem }
            }
        }
        fatalError("No shared item found????")
    }
    
    
}

struct PointsManager {
    
    let sharedItems: [String]
    
    private let priorities: [String: Int] = ["a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6, "g": 7, "h": 8, "i": 9, "j": 10, "k": 11, "l": 12, "m": 13, "n": 14, "o": 15, "p": 16, "q": 17, "r": 18, "s": 19, "t": 20, "u": 21, "v": 22, "w": 23, "x": 24, "y": 25, "z": 26, "A": 27, "B": 28, "C": 29, "D": 30, "E": 31, "F": 32, "G": 33, "H": 34, "I": 35, "J": 36, "K": 37, "L": 38, "M": 39, "N": 40, "O": 41, "P": 42, "Q": 43, "R": 44, "S": 45, "T": 46, "U": 47, "V": 48, "W": 49, "X": 50, "Y": 51, "Z": 52]
    
    func combinedPriorityTotal() -> Int {
        return sharedItems.reduce(0) { partialResult, sharedItem in
            partialResult + (priorities[sharedItem] ?? 0)
        }
    }
    
}

do {
    guard let path = Bundle.main.url(forResource: "input", withExtension: "txt") else { fatalError() }
    let pattern = Array(repeating: ["", "", ""], count: 100)
    let rucksacks = try String(contentsOf: path, encoding: .utf8)
        .components(separatedBy: "\n")
    var iter = rucksacks.makeIterator()
    let badgeSum = pattern.map { $0.compactMap { _ in iter.next() } }
        .reduce(0, { partialResult, groupedRucksacks in
            let rucksacks = groupedRucksacks.map { Rucksack(wholeRucksack: $0 ) }
            let sharedItem = GroupMatcher(rucksacks: rucksacks).findSharedItem()
            let totalPointsFromSharedItems = PointsManager(sharedItems: [sharedItem]).combinedPriorityTotal()
            return partialResult + totalPointsFromSharedItems
        })
    print(badgeSum)
    
} catch(let error) {
    print(error)
}

