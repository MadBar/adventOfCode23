//
//  ViewController.swift
//  AoC23-2a
//
//  Created by Madeleine Barwén on 2023-12-03.
//

import UIKit

class ViewController: UIViewController {

    var maxColorCubes = ["red": 12, "green": 13, "blue": 14]
    var possibleGames = [Int]() // type Int array
    var linesGoneOver = 0 // type Int

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // open file with game data puzzle input mini
        let path = Bundle.main.path(forResource: "puzzle-input", ofType: "txt")!
        //let path = Bundle.main.path(forResource: "puzzle-input", ofType: "txt")!

        // read file
        let data = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        //separate each line (don't know if unnessecary)
        let lines = data.components(separatedBy: "\n") // lines type array of strings

        // step 1 just print each line
        for line in lines {

            //check that line is not empty
            if line.isEmpty {
              //  print("line is empty")
                continue
            } 

            print(line) // line type string

            // Get Game ID Int
            let gameIDInt = gameIDDigits(line: line) // type Int - eg. 1 or 10

            // trim first 7(index 6) chars of the line
            let sevethChar = line[line.index(line.startIndex, offsetBy: 6)] //
            let trimmedLine: Substring

            // Game ID is double digits eg. 10
            if gameIDInt > 9 {

                //print line, the 7th char
                print(line, ", | Game ID has 2 digits (7th char is a digit)")
                print("sevethChar: ", sevethChar)
                trimmedLine = line.dropFirst(8) // type substring eg. "10: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"

            } else { //Game ID is single digit eg. 1
                print(line, ", | Game ID has 1 digit (7th char is NOT a digit)")
                print("sevethChar: ", sevethChar) 
                trimmedLine = line.dropFirst(7) // type substring eg. "1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"        
            }

            let gamePossibilityVerdict = checkIfPossible(trimmedLine: String(trimmedLine), line)

            if gamePossibilityVerdict {
                print("game is possible")
                addPossibleGames(gameIDInt) // add game id to possible games

            } else {
                print("game is NOT possible")
            }
            linesGoneOver += 1
            print("Lines gone over: ", linesGoneOver, ", possibleGames: ", possibleGames) 
        }

        print("All is printed")
        //print possible games
        print("possible games: ", possibleGames )
        
        // sum all values in possible games
        let sumOfPossibleGames = possibleGames.reduce(0, +)
        print("sumOfPossibleGames: ", sumOfPossibleGames)

    }

    func checkIfPossible(trimmedLine: String, _ line: String) -> Bool {
        var gameIsPossible = true // type Bool
        var possibleRounds = 0 // type Int - eg. 3
        var possibleSegments = 0 // type Int - eg. 1

        // split line into rounds
        let roundsInGame = trimmedLine.components(separatedBy: ";") // roundsInGame type array of strings
                // eg. ["3 blue, 4 red", "1 red, 2 green, 6 blue", "2 green"]
        var amountOfRounds: Int = roundsInGame.count // type Int - eg. 3
        var amountOfSegments: Int = 0 // type Int - eg. 1
        print("amountOfRounds: ", amountOfRounds) // eg. 3  type Int

        // split rounds into segments
        for round in roundsInGame {
            print("round: \(round)") // eg. 3 blue, 4 red

            let cubesInRound = round.components(separatedBy: ",") // cubesInRound type array of strings
            print("cubesInRound: \(cubesInRound)") // eg. ["3 blue", " 4 red"]

            // split cubes into color and amount
            for segment in cubesInRound {
                print("segment untrimmed whitesapace: \(segment)") // eg. 3 blue. type string

                //trim whitespace from segment
                let segment = segment.trimmingCharacters(in: .whitespaces)
                print("segment TRIMMED whitesapace: \(segment)") // eg. 3 blue. type string

                let colorAndAmount = segment.components(separatedBy: " ") // type array of strings
                print("colorAndAmount: \(colorAndAmount)") // eg. ["3", "blue"]
                
                let segmentColor = colorAndAmount[1]
                print("segmentColor: \(segmentColor)") // eg. blue
                
                let segmentAmount = colorAndAmount[0]
                print("segmentAmount: \(segmentAmount)") // eg. 3
                
                // check if color is in maxColorCubes
                if maxColorCubes[segmentColor] != nil {

                    // check if Segmentamount is less than or equal to maxColorCubes color amount
                    if Int(segmentAmount)! <= maxColorCubes[segmentColor]! {
                        print("segment is Possible - less than or equal to maxColorCubes")
                        // possible
                       // possibleRounds += 1 // type Int

                    } else {
                        print("segment is NOT possible - more than maxColorCubes")

                        //exit to next round in line in lines
                        gameIsPossible = false
                        break

                        // not possible
                    }
                } else {
                    print("color is not in maxColorCubes")
                    break // exit to next round in line in lines? 
                    // not possible
                }
            }
        }

        return gameIsPossible
    }

    func addPossibleGames(_ gameIDInt: Int) {
        // add the possible games to an array
        print("GameIDInt: ", gameIDInt)

        //add game id to possible games
        possibleGames.append(gameIDInt)
    }

    //func to decide if Game ID is 1 or 2 digits
    func gameIDDigits(line: String) -> Int {

        let dropFirst = line.dropFirst(4)
           print("dropFirst:", dropFirst)

           if let colonIndex = dropFirst.firstIndex(of: ":") {
               var gameIDString = dropFirst.prefix(upTo: colonIndex).trimmingCharacters(in: .whitespaces)
               print("Substring before colon:", gameIDString)

               // Filter out non-numeric characters
               gameIDString = gameIDString.filter { $0.isNumber }

               if let gameIDInt = Int(gameIDString) {
                   print("Successfully converted to Int:", gameIDInt)
                   return gameIDInt
               } else {
                   print("Conversion to Int failed.")
               }
           } else {
               print("Colon not found in the string")
           }

           return 0  // Default value if conversion fails or colon is not found
    }
}

