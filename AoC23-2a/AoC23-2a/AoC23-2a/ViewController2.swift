//
//  ViewController.swift
//  AoC23-2a
//
//  Created by Madeleine Barwén on 2023-12-03.
//
///What games are possible? Then add them together for a total Int
///
/// how do you know how many cubes exist of a color?
/// each game - heäll hide unknown amount of cubes in each color
///
///Sample:
/////Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
///Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
///Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
///Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
///Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
///
/// Bag only has: 12 red cubes, 13 green cubes, and 14 blue cubes
/// What games would have been possible
///
/// Answer: Possible: 1,2, 5   - so total Int = 8
///

import UIKit

/* class ViewController2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad() */
        // Do any additional setup after loading the view.
//
//        let game1 = game()
//        game1.addCubes(color: .blue, amount: 3)
//        game1.addCubes(color: .red, amount: 4)
//        game1.addCubes(color: .red, amount: 1)
//        game1.addCubes(color: .green, amount: 2)
//        game1.addCubes(color: .blue, amount: 6)
//        game1.addCubes(color: .green, amount: 2)
//
//        let game2 = Game()
//        game2.addCubes(color: .blue, amount: 1)
//        game2.addCubes(color: .green, amount: 2)
//        game2.addCubes(color: .green, amount: 3)
//        game2.addCubes(color: .blue, amount: 4)
//        game2.addCubes(color: .red, amount: 1)
//        game2.addCubes(color: .green, amount: 1)
//        game2.addCubes(color: .blue, amount: 1)
//
//        let game3 = Game()
//        game3.addCubes(color: .green, amount: 8)
//        game3.addCubes(color: .blue, amount: 6)
//        game3.addCubes(color: .red, amount: 20)
//        game3.addCubes(color: .blue, amount: 5)
//        game3.addCubes(color: .red, amount: 4)
//        game3.addCubes(color: .green, amount: 13)
//        game3.addCubes(color: .green, amount: 5)
//        game3.addCubes(color: .red, amount: 1)
//
//        let game4 = Game()
//        game4.addCubes(color: .green, amount: 1)
//        game4.addCubes(color: .red, amount: 3)
//        game4.addCubes(color: .blue, amount: 6)
//        game4.addCubes(color: .green, amount: 3)
//        game4.addCubes(color: .red, amount: 6)
//        game4.addCubes(color: .green, amount: 3)
//        game4.addCubes(color: .blue, amount: 15)
//        game4.addCubes(color: .red, amount: 14)
//
//        let game5 = Game()
//        game5.addCubes(color: .red, amount: 6)
//        game5.addCubes(color: .blue, amount: 1)
//        game5.addCubes(color: .green, amount: 3)
//        game5.addCubes(color: .blue, amount: 2)
//        game5.addCubes(color: .red, amount: 1)
//        game5.addCubes(color: .green, amount: 2)
//
//        let games = [game1, game2, game3, game4, game5]
//        var possibleGames = 0   // total Int
//
//        for game in games {
//            if game.isPossible() {
//                possibleGames += 1
//            }
//        }
//        print("Possible games: \(possibleGames)")

  //  }
//
//    func game() -> Game {
//        let game = Game()
//        return game
//    }

//}


/* 
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

     /*    var maxRed = 12
        var maxGreen = 13
        var maxBlue = 14     */

        // instead of vars make a dictionary with color as key and amount as value
        // var maxCubes = [String: Int]()
        var maxColorCubes = ["red": 12, "green": 13, "blue": 14]

        // possible games var
        var possibleGames = [Int]() // type Int array

        // open file with game data puzzle input mini
        let path = Bundle.main.path(forResource: "puzzle-input-mini", ofType: "txt")!
        //let path = Bundle.main.path(forResource: "puzzle-input", ofType: "txt")!

        // read file
        let data = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        //separate each line (don't know if unnessecary)
        let lines = data.components(separatedBy: "\n") // lines type array of strings

        // step 1 just print each line
        for line in lines {
            print(line)

            // read through string printing out each number (print eg 134 as 134 and not 1\n 3\n 4\n), after 6th char 
            line = line.components(separatedBy: ";") // line type string

            /* line.enumerated().forEach { index, char in
                if index > 5 {
                    if char.isNumber {
                        print("number: \(char)")


                    }
                }
            }

            // read through string printing out each color right of that number
            line.enumerated().forEach { index, char in
                if index > 5 {
                    if char.isLetter {
                    print("color: \(char)")
                    }
                }
            }
         */

            // look at each nr and color next to it, to check against var maxColorCubes dict, take the color string and use as key to search maxColorCubes to find out it the number is the same or below the maxColorCubes number for that color

        }

        // With each line - populate a new dict eg. Dict "Game x". 
        // Name each lines dict with the same nr as the itteration (starting at 0 but game starts at 1 so address that)
        // Then add each line to the dict separating the color and amount of cubes 
        // (maybe make a function for this)
        // Then check if the game is possible (make a function for this)
        // If possible add the number in the name of the dict that was possible to an array of possible games


        // dont need to make a dict for each game/line - just make a dict for each that is possible
        // make a dict for each line
        //loop throug each line checking if each number left of the color

       /*  for line in lines {

            // look at each nr and color next to it, to check against var maxColorCubes dict, take the color string and use as key to search maxColorCubes to find out it the number is the same or below the maxColorCubes number for that color
            // if it is - Store the Game ID (eg. "Game 1" then the ID is 1), in the array of possible games "possibleGames"

            // if the number is higher than the maxColorCubes number for that color - break the loop and go to the next line        
            let line = line.components(separatedBy: " ")
            let color = line[1]
            let amount = Int(line[0])!
            print("color: \(color), amount: \(amount)")
            
            if color == "red" {
                maxRed -= amount
            } else if color == "green" {
                maxGreen -= amount
            } else if color == "blue" {
                maxBlue -= amount
            }
        } */

   
    }

    
    
    func checkIfPossible() {
        // check if the game is possible (make a function for this)
        
        // If possible add the number in the name of the dict that was possible to an array of possible games
    }

    func addPossibleGames() {
        // add the possible games to an array
    }

    func printPossibleGames() {
        // print the possible games
    }

    func addPossibleGamesTogether() {
        // add the possible games together
    }

    func printAnswer() {
        // print the answer
    }
}


 */
