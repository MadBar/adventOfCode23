//
//  ViewController.swift
//  AoC23-5a
//
//  Created by Madeleine Barwén on 2023-12-05.
//  https://adventofcode.com/2023/day/5
//
/// The Gardener/Farmer:
/// What is the lowest location number that corresponds to any of the initial seed numbers?
///
/// 1. destination range start  2. source range start  3. range length
/// EG. soil range start: 50, seed range start: 98, range length: 2
///
/// To recap and see if you're onboard: Look at input-mini file and predict the eventual location numbers eg.
/// - Seed,  soil,  fertilizer,  water,  light,  temperature,  humidity,  location
/// - 79, 81, 81, 81, 74, 78, 78, 82
/// - 14, 14, 53, 49, 42, 42, 43, 43
/// - 55, 57, 57, 53, 46, 82, 82, 86
/// - 13, 13, 52, 41, 34, 34, 35, 35
/// Look for seed nr 79 in the source (2nd) number+range (3rd) number
/// - Is 79 in 98-99? No
/// - is it within 50-(50+48(-1)=)97? Yes
/// At what position is 79 in the source range 50...97?
/// - 79-50=29
/// Apply that position to from the source start nr to get source value:
/// - 52+29=81
/// And so on!
///

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //declare global variables
        var lowestLocationNr = 0 // lowest location number

        struct LineData { // struct of 3 ints
            var value1: Int
            var value2: Int
            var value3: Int
        }

        // Read File - produce array of strings "lines"
        let lines = readFile() //type: [String]

        // Get only the SEEDS as an array of ints
        let seeds = separateOutSeeds(lines: lines)
        var mapDictionary = [String: [LineData]]()
        // variable that holds the mapnames in order
        var mapNames = [String]() // type: [String]

        // for input-mini
        // populate mapDictionary with keys being the variable names for the following 7 struct variables below and the values being their values
        //        mapDictionary["seedToSoilMap"] = LineData(value1: 50, value2: 98, value3: 2)
        //        mapDictionary["seedToSoilMap"] = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 3, dropLinesAfter: 29)
        //        mapDictionary["soilToFertilizerMap"] = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 7, dropLinesAfter: 24)
        //        mapDictionary["fertilizerToWaterMap"] = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 12, dropLinesAfter: 18)
        //        mapDictionary["waterToLightMap"] = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 18, dropLinesAfter: 14)
        //        mapDictionary["lightToTemperatureMap"] = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 22, dropLinesAfter: 9)
        //        mapDictionary["temperatureToHumidityMap"] = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 27, dropLinesAfter: 5)
        //        mapDictionary["humidityToLocationMap"] = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 31, dropLinesAfter: 1)

        // for input.txt
        mapDictionary["seedToSoilMap"] = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 3, dropLinesAfter: 203)
        mapDictionary["soilToFertilizerMap"] = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 36, dropLinesAfter: 154)
        mapDictionary["fertilizerToWaterMap"] = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 85, dropLinesAfter: 107)
        mapDictionary["waterToLightMap"] = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 132, dropLinesAfter: 62)
        mapDictionary["lightToTemperatureMap"] = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 177, dropLinesAfter: 40)
        mapDictionary["temperatureToHumidityMap"] = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 199, dropLinesAfter: 21)
        mapDictionary["humidityToLocationMap"] = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 218, dropLinesAfter: 1)

        // Append mapNames with the names of all the maps
        mapNames.append("seedToSoilMap")
        mapNames.append("soilToFertilizerMap")
        mapNames.append("fertilizerToWaterMap")
        mapNames.append("waterToLightMap")
        mapNames.append("lightToTemperatureMap")
        mapNames.append("temperatureToHumidityMap")
        mapNames.append("humidityToLocationMap")

        var sourceNumber = 0 // type: Int
        var destinationNumber = 0 // type: Int
        var seedLoopCounter = 1
        var mapLoopCounter = 1
        var categoryPossibleRowsTemp = [String]() // type: [String]
        var rangePosition = 0 // type: Int

        // make big loop for going through all seeds to locations
        for seed in seeds {

            print("Seed loop counter omgång: \(seedLoopCounter)")
            print("Seed: \(seed)")

            sourceNumber = seed

            for x in 0...6 {
                print("'7 loop' entered. On map: \(x) of 0-6")
                mapLoopCounter = 1

                if x == 0 {
                    // instead of mapName take the first key using indexing from mapDictionary
                    destinationNumber = findDestinationNr(sourceNumber, mapNames[x])
                    print("Seed nr: \(seedLoopCounter)\nMap/iteration nr: \(x) from Map: \(mapNames[x]) with SourceNr \(sourceNumber) produced DestinationNr: \(destinationNumber), next Map: \(mapNames[x+1]) shall use it as SourceNr")

                } else {
                    let updatedSource = destinationNumber

                    destinationNumber = findDestinationNr(updatedSource, mapNames[x])

                    if x <= 5 {
                        print("Seed nr: \(seedLoopCounter)\nMap/iteration nr: \(x) from Map: \(mapNames[x]) with SourceNr \(updatedSource) produced DestinationNr: \(destinationNumber), next Map: \(mapNames[x+1]) shall use it as SourceNr")
                    } else {
                        print("Seed nr: \(seedLoopCounter)\nMap/iteration nr: \(x) from Map: \(mapNames[x]) with SourceNr \(updatedSource) produced DestinationNr: \(destinationNumber)")
                        print("Seed \(seed)s LocationNr is hence: \(destinationNumber)")

                        // Assign lowestLocationNr to first destinationNumber it it's the first seed
                        if seedLoopCounter == 1 {
                            lowestLocationNr = destinationNumber
                            print("lowestLocationNr is now: \(lowestLocationNr)")
                            print("To the next Seed!")
                            // break out to the next seed
                            break
                        }

                        // Check if destina is lower than lowestLocationNr
                        if destinationNumber < lowestLocationNr {
                            // Store destination as new lowestLocationNr
                            print("LowestLocationNr was: \(lowestLocationNr) but will be reassigned the lower destinationNr: \(destinationNumber)")
                            lowestLocationNr = destinationNumber
                            print("lowestLocationNr is now: \(lowestLocationNr)")
                            print("To the next Seed!")
                        } else {
                            print("LowestLocationNr was: \(lowestLocationNr) and will not be reassigned")
                            print("To the next Seed!") //xxxx
                        }
                    }
                }

                sourceNumber = destinationNumber
                mapLoopCounter = 1
            }

            seedLoopCounter += 1
        }

        print("\nThe Lowest Location Nr and the output for AoC Day 5 is: \(lowestLocationNr) \nDone")

        // ------------------------- FUNCTIONS----------------------------

        func readFile() -> [String]{
            let path = Bundle.main.path(forResource: "input", ofType: "txt")! // type: String
            let data = try! String(contentsOfFile: path, encoding: String.Encoding.utf8) // type: String
            let lines = data.components(separatedBy: "\n") // type: [String]

            return lines
        }

        func separateOutSeeds(lines: [String]) -> [Int] {

            // Save only the first line into a variable
            let seedsLine = lines[0]    // type: String

            // Drop initial characters up until first number of any kind
            let seedsLineStartDropped = seedsLine.drop(while: { $0.isNumber == false })

            // make seedsLineStartDropped into an array of ints
            let seedsLineStartDroppedArray = seedsLineStartDropped.components(separatedBy: " ").compactMap{ Int($0) }

            // return all seeds in an array of ints
            return seedsLineStartDroppedArray
        }

        func trimStringTurnIntoIntArray(lines: [String], dropLinesBefore: Int, dropLinesAfter: Int) -> [LineData] {

            // Drop lines before and after relevant lines
            var linesSelection = Array(lines.dropFirst(dropLinesBefore)) //type: [String]
            linesSelection = Array(linesSelection.dropLast(dropLinesAfter)) //type: [String]

            // Turn linesSelection into a LineData struct
            var lineDataStruct: [LineData] = [] //type: [LineData] struct


            for line in linesSelection {

                let components = line.components(separatedBy: " ").compactMap { Int($0) } // components: [Int]

                if components.count == 3 {
                    let lineData = LineData(value1: components[0], value2: components[1], value3: components[2])
                    lineDataStruct.append(lineData)

                } else {
                    // Handle the case where the line doesn't have three integers
                    print("Invalid line format: \(line)")
                }

            }

            // return all lines from category in a struct with 3 ints
            return lineDataStruct //type: [LineData] struct - 3 ints
        }

        // Make func that takes a source nr int and a map name as a string eg. soilToFertilizerMap and returns a destination nr.
        func findDestinationNr(_ sourceNr: Int, _ mapName: String) -> Int {

            print("SourceNr: \(sourceNr), mapName: \(mapName)")

            let mapLinedata = mapDictionary[mapName]

            for lineData in mapLinedata! {
                print(lineData)
                // Source is below lowest source number. lineData.value2 is the source number
                if sourceNr < lineData.value2 {
                    print("SourceNumber \(sourceNr) is below source start number (\(lineData.value2)) for this line of \(mapName). Assigning destination as source for now and checking if more lines")

                    // write "sourceBelowLowest" into list of categoryPossibleRowsTemp
                    categoryPossibleRowsTemp.append("sourceBelowLowest")

                    destinationNumber = sourceNr
                    print("destinationNumber: \(destinationNumber)")

                } else {

                    print("sourceValue (\(sourceNr))")

                    //Seed is above heighest source nr (source number + (range value-1))
                    if sourceNr > lineData.value2 + lineData.value3 - 1 { //lineData.value3 is the range value
                        categoryPossibleRowsTemp.append("sourceAboveHighest")
                        print("sourceValue is above (source number+range value) and hence out of range this row. Assigning destination as source for now")
                        destinationNumber = sourceNr
                        print("source number: \(sourceNr)")
                        print("Destination number: \(destinationNumber)")
                        print("Source nr should be same as destination nr")
                    } else { // Seed in range
                        print("Source is within range")
                        // write "sourceWithinRange" into list of categoryPossibleRowsTemp
                        categoryPossibleRowsTemp.append("sourceWithinRange")

                        // find rangePosition of source/seed
                        rangePosition = sourceNr - lineData.value2 // lineData.value2 is the source number start

                        //assign destination number
                        destinationNumber = lineData.value1 + rangePosition
                        print("destinationNumber: \(destinationNumber)")
                        print("Breaking out")
                        print("End line: \(mapLoopCounter) \n")

                        // break out of the for lines in linedata
                        break
                    }
                }

                print("End line: \(mapLoopCounter) \n")

                mapLoopCounter += 1

                //drop all data inside categoryPossibleRowsTemp
                categoryPossibleRowsTemp.removeAll()
            }

            return destinationNumber
        }
    }
}
