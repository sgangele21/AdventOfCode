import UIKit
import XCPlayground
import PlaygroundSupport

struct CaloriesCarriedByElve: Comparable {
    
    static func < (lhs: CaloriesCarriedByElve, rhs: CaloriesCarriedByElve) -> Bool {
        lhs.totalCalories < rhs.totalCalories
    }
    
    let calories: [Int]
    var totalCalories: Int {
        self.calories.reduce(0) { partialResult, num in
            partialResult + num
        }
    }
}

do {
    guard let path = Bundle.main.url(forResource: "input", withExtension: "txt") else { fatalError() }
    let topElf = try String(contentsOf: path, encoding: .utf8)
        .components(separatedBy: "\n\n")
        .map { $0.components(separatedBy: "\n") }
        .map { CaloriesCarriedByElve(calories: $0.compactMap { Int($0) }) }
        .max()
    
    print(topElf?.totalCalories)
    
    let topThreeElvesCalories = try String(contentsOf: path, encoding: .utf8)
        .components(separatedBy: "\n\n")
        .map { $0.components(separatedBy: "\n") }
        .map { CaloriesCarriedByElve(calories: $0.compactMap { Int($0) }) }
        .sorted()
        .suffix(3)
        .reduce(0, { partialResult, caloriesCarriedByElve in
            partialResult + caloriesCarriedByElve.totalCalories
        })
    print(topThreeElvesCalories)
    
    
} catch(let error) {
    print(error)
}

