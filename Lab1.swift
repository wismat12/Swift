import UIKit
// tego nie oddajemy
var str = "Hello, playground"
var myInteger = 27
var myDouble = 27.0

//2
let strConst: String = "aaa"
let intConst: Int = 1
let doubleConst: Double = 1.0

//3
var concat1 = str + " " + String(myDouble)

var concat2 = str + " " + "\(myDouble)"

//4
var fruits = ["apple", "orange", "pear"]
var anything = [1,1.0,"1"] as [Any]

let emptyArray = [String]()

//https://www.weheartswift.com/dictionaries/
//To declare a dictionary you can use the square brackets syntax([KeyType:ValueType]).

let emptyDictionary = [String: Float]()
var dictionary: [String:Int] = [
    "one" : 1,
    "two" : 2,
    "three" : 3
]

print(dictionary["two"] ?? "nothing found")

//5
//https://developer.apple.com/documentation/swift/array

fruits.append("lemon")
dictionary["ten"] = 10
print(dictionary["ten"]!)

//6
var lotto: [String: Array<Int>] = [
    "29-11-14" : [4, 5, 21, 30, 31, 49],
    "27-11-14" : [5, 8, 10, 19, 23, 40]
]
print(lotto["29-11-14"]!)

//7
var emptyAsc = [Character: Int]()
//8
for i in 1...10 {
    emptyAsc[Character(UnicodeScalar(Int(UnicodeScalar("A").value) + i - 1)!)] = i
}
print(emptyAsc)

//9
for date in lotto.keys{
    print("Losowanie dnia \(date):")
    for number in lotto[date]!{
        print(" - \(number)\n")
    }
}

//10
