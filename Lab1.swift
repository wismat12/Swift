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
//Napisz funkcję, która przyjmuje dwie liczby całkowite jako parametry i zwraca ich największy wspólny dzielnik. 
func nwd(first: Int, second: Int) -> Int{
    
    var a: Int
    
    if(second != 0){
        a = first % second
        return nwd(first:second,second:a) 
    }
    return first 
 
}
var out = nwd(first:45,second:60)
print(out)

// jak same liczby nwd2(30,40) to Error: cannot assign to value: 'second' is a 'let' constant
//immutable param
func nwd2(first: Int, second: Int) -> (d:Int, fq:Int, sq:Int){
    
    var a: Int
    var f = first
    var s = second
    
    var ff = first
    var ss = second
    
    while(ss != 0){
        a = ff % ss
        ff = ss
        ss = a
    }
    return (ff, f/ff, s/ff)
}
print(nwd2(first:45,second:60))

//Closure
var lotto2: [String: Array<Int>] = [
    "29-11-14" : [4, 5, 21, 30, 31, 49],
    "27-11-14" : [5, 8, 10, 19, 23, 40]
]
for date in lotto2.keys{
    lotto2[date].map({(number: Int) -> Int in return ((number%2)==0) ? 0 : 1})
}
