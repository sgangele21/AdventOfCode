import Foundation

struct CaloriesCarriedByElve {
    let calories: Int
}

do {
    let fileContents = try String(contentsOfFile: "/Users/sahilgangele/Documents/Playgrounds/AdventOfCode2022/Day1/input.txt", encoding: .utf8)
    let listOfStrings = fileContents.components(separatedBy: "\n\n")
    print(listOfStrings)

//    print(fileContents)
} catch(let error) {
    print(error)
}



