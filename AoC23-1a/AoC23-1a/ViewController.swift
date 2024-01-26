//
//  ViewController.swift
//  AoC23-1a
//
//  Created by Madeleine Barwén on 2023-12-01.
//

// new approach is to only keep the numbers on each line, when select the first and last on each row. But still neet to exclude white spaces as gpt says

// dela upp i rader som sedan kan göras first och last på

// Om jag gör en array av alla rader, så kan jag göra first och last på varje rad.

// Om bara ett nummer på en rad, blir first and last samma siffra - bra


import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var bigTotal = 0        // total sum of all numbers 

        // open text file data mini
        if let filePath = Bundle.main.path(forResource: "data", ofType: "txt") {
            do {
                //extract contents
                let fileContent = try String(contentsOfFile: filePath, encoding: .utf8)
                
                // split into lines
                let lines = fileContent.components(separatedBy: "\n")

                //print(lines)
                print("lines:", lines.count)

                //trim whitespaces and newlines
                let fileContentTrimmed = fileContent.trimmingCharacters(in: .whitespacesAndNewlines)

                //print(fileContentTrimmed)
                print("fileContentTrimmed:", fileContentTrimmed)
                
                // split trimmed into lines
                let linesTrimmed = fileContentTrimmed.components(separatedBy: "\n")
                print("linesTrimmed:", linesTrimmed.count)
                

                //pick out only the first character
                if let first = fileContent.first {
                    print("this is the first only:", first)

                } else {
                    print("File was empty!")
                }

                //pick out only the last character
                if let last = fileContentTrimmed.last {
                        print("this is the last only:", last)

                } else {
                    print("File was empty!")
                }

                // Now, fileContent contains the content of the text file
                print(fileContent)

                // Now, linesTrimmed contains an array or the rows
                // print("linesTrimmed Array:", linesTrimmed)

                // loop through the array and print first and last character of each row
                for line in linesTrimmed {      
                    var firstDigit = 0
                    var lastDigit = 0


                    // Use regular expression to find the first single-digit number in the line
                    if let firstDigitMatch = line.rangeOfCharacter(from: CharacterSet.decimalDigits, options: .literal) {
                        firstDigit = Int(String(line[firstDigitMatch]))!
                        print("line:", line, "firstDigit:", firstDigit ?? "Not a single-digit number")
                        
                        /* // You can continue with your processing here, e.g., adding to bigTotal
                        if let validFirstDigit = firstDigit {
                            bigTotal += validFirstDigit
                        } */
                    }

                    // Use regular expression to find the last single-digit number in the line
                    if let lastDigitMatch = line.rangeOfCharacter(from: CharacterSet.decimalDigits, options: .backwards) {
                        lastDigit = Int(String(line[lastDigitMatch]))!
                        print("line:", line, "lastDigit:", lastDigit ?? "Not a single-digit number")
                        
                        /* // You can continue with your processing here, e.g., adding to bigTotal
                        if let validLastDigit = lastDigit {
                            bigTotal += validLastDigit
                        } */
                    }

                    // Combine the two int numbers, not summaed
                    if let validFirstDigit:Optional = firstDigit, let validLastDigit:Optional = lastDigit {
                        let combined: Int = (validFirstDigit ?? 0) * 10 + (validLastDigit ?? 0)
                        print("combined:", combined)

                        // add the variable "combined" to bigTotal
                        bigTotal += combined    
                        print("bigTotal:", bigTotal)
                          
                    } 
                    
                          

                }


// --- produced wrong output too big                
//                 for line in linesTrimmed {
//                      // split into numbers

//  let lineNumbers = line.components(separatedBy: CharacterSet.decimalDigits.inverted)
//                     // remove empty strings
//                     .filter { !$0.isEmpty }
//                     // convert to Int
//                     .compactMap { Int($0) }

//                     // print first and last number
//                     if let first = lineNumbers.first, let last = lineNumbers.last {
//                         print("lineNumbers:", lineNumbers, "first:", first, "last:", last, "first + last:", first + last)
//                             let lineResult = String(first) + String(last)
//                             if let intResult = Int(lineResult) {
//                                 print("intResult:", intResult)
//                                 bigTotal = bigTotal + intResult
//                             } else {
//                                 print("conversion failed")
//                             }
//                             print("bigTotal:", bigTotal)
                            
//                     } 
                // }
// --- produced wrong output too big


                // 
                let total = linesTrimmed.reduce(0) { (accumulator, element) in
                    
                    if let number = Int(element) {
                        print("Element type:", element, "Converted to Int:", number, "Accumulator:", accumulator, "Total:", accumulator + number)
                        
                        return accumulator + number
                    } else {
                        return accumulator
                    }

                }
                
                // last print
                print("total:", total)

            } catch {
                print("Error reading contents of the file: \(error)")
            }
        } else {
            print("File not found.")
        }

    }

}

