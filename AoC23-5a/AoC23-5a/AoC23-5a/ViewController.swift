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
/// Entire Program suceeds (with input-mini) if the output is 35
///
/// Get started today:
/// 1. See if my program prints out correct nrs according to the recap above.
///
///
/// - Loop through seeds (to ultimately find the lowest location number)
/// -- - take a seed (find it's location nr -> save location nr to compare with rest of seeds)
/// -- --- Find out seeds soil nr (below-, withing or above range)
/// -- --- - Find out soils fertilizer nr (below-, withing or above range)
/// -- --- -- Find out fertilizers water nr (below-, withing or above range)
/// -- --- --- Find out waters light nr (below-, withing or above range)
/// -- --- ---- Find out lights temperature nr (below-, withing or above range)
/// -- --- ----- Find out temperatures humidity nr (below-, withing or above range)
/// -- --- ------ Find out humidities location nr (below-, withing or above range)
/// -- --- ------- Save location nr. if first seed, save it as lowest location nr, after that only save if lower than lowest location nr
///
///
/*  50 98 2
 52 50 48
 The first line has a destination range start of 50, a source range start of 98, and a range length of 2.
 This line means that the source range starts at 98 and contains two values: 98
 and 99. The destination range is the same length, but it starts at 50, so its two values are 50 and 51. With this information, you know that seed number 98 corresponds to soil number 50 and that seed number 99 corresponds to soil number 51.

 */
/// Food production problem
/// Can't make sense of Almanac (Almanac = Puzzle Input)
/// Almanack:
///     A. lists all SEEDS needing to be planted
///     1.seed-to-soil  (Type of soil to use w. each kind of seed)
///     2. soil-to-fertilizer
///     3. fertilizer-to-water
///     4. water-to-light
///     5. light-to-temperature
///     6. temperature-to-humidity
///     7. humidity-to-location
///
/// Nrs are reused (soil 123 and fertilizer 123 aren't necessarily related to each other.
/// MAPS describes how to convert nrs from SOURCE category to DESTINATION
/// 2 catehories: SOURCE & DESTINATION
/// Each of 7 maps has 1 SOURCE and 1 DESTINATION
/// Eg. in "seed-to-soil" map
///     SEED NR = The SOURCE , SOIL NR = DESTINATION
/// MAPS describes RANGES of Nr can be converted
/// MAPS contain 3 NUMBERS
/// NUMBER 1: DESTINATION RANGE START
/// NUMBER 2: SOURCE RANGE START
/// NUMBER 3: RANGE LENGTH (how many values - a "2" means it has 2 values)
/// SOURCE numbers that aren't mapped correspond to the same destination number. So, seed number 10 corresponds to soil number 10.
///
/// MAP MEANS:
/// - DESTINATION range starts at 50 and contains TWO values: 50 and 51:
///     - Seed 50
/// - SOURCE range starts at 98 and contains TWO values: 98 and 99
///    - Soil 98
///
/// 1. What's closest location/LOWEST LOCATION NR needing a seed?
///     - convert each seed number through other categories until you can find its corresponding location number

/// Questions before starting:
/// 1. Is the length of source and destination always the same for a row?  (now between different rows)
/// 2. What is the matrix above?
/// 3. How have they calculated the seed and soil examples?
/// 4. Understand how to work the examples above to find location
///

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var debugCounter = 0

        //declare global variables
        var lowestLocationNr = 0 // lowest location number
        var allLocations = [Int]()  // array of all location numbers

        struct LineData { // struct of 3 ints
            var value1: Int
            var value2: Int
            var value3: Int
        }

        // Read File - produce array of strings "lines"
        let lines = readFile() //type: [String]

        // Get only the SEEDS as an array of ints
        let seeds = separateOutSeeds(lines: lines)

        // for input.txt file: Category MAPs as a structs of Ints
        //        let seedToSoilMap = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 3, dropLinesAfter: 203)
        //        let soilToFertilizerMap = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 36, dropLinesAfter: 154)
        //        let fertilizerToWaterMap = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 85, dropLinesAfter: 107)
        //        let waterToLightMap = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 132, dropLinesAfter: 62)
        //        let lightToTemperatureMap = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 177, dropLinesAfter: 40)
        //        let temperatureToHumidityMap = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 218, dropLinesAfter: 1)
        // Need to add humidityToLocationMap!!!!!!!!

        // declare a variable that can hold keys and values, where keys are strings and values are linedata structs of ints. Eg. [seedToSoilMap: trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 3, dropLinesAfter: 29)]
        var mapDictionary = [String: [LineData]]()
        // need to make this dict ordered : var orderedDictionary: [(key: KeyType, value: ValueType)] = []
        //Make a variable that holds the mapnames in order
        var mapNames = [String]() // type: [String]



        // GET RID OF THIS WHEN LOGIC USES THE MAPDIRECTORY INSTEAD OF INDIVIDUAL MAPS
        // Category MAPs as Linedata structs of Ints. input-mini.txt file
        //        let seedToSoilMap = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 3, dropLinesAfter: 29)
        //        let soilToFertilizerMap = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 7, dropLinesAfter: 24)
        //        let fertilizerToWaterMap = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 12, dropLinesAfter: 18)
        //        let waterToLightMap = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 18, dropLinesAfter: 14)
        //        let lightToTemperatureMap = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 22, dropLinesAfter: 9)
        //        let temperatureToHumidityMap = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 27, dropLinesAfter: 5)
        //        let humidityToLocationMap = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 31, dropLinesAfter: 1)

        // for input-mini
        //populate mapDictionary with keys being the variable names for the following 7 struct variables below and the values being their values
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

//        let seedToSoilMap = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 3, dropLinesAfter: 203)
//        let soilToFertilizerMap = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 36, dropLinesAfter: 154)
//        let fertilizerToWaterMap = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 85, dropLinesAfter: 107)
//        let waterToLightMap = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 132, dropLinesAfter: 62)
//        let lightToTemperatureMap = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 177, dropLinesAfter: 40)
//        let temperatureToHumidityMap = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 218, dropLinesAfter: 1)
//        let humidityToLocationMap = trimStringTurnIntoIntArray(lines: lines, dropLinesBefore: 222, dropLinesAfter: 1)
//        // Need to add humidityToLocationMap!!!!!!!!

        // pupulate a linedata variable from mapDictionary where key is seedToSoilMap
        //        let seedToSoilMap = mapDictionary["seedToSoilMap"]! // reason for exclamaition mark is because we know it will always exist

        // Append mapNames with the names of all the maps
        mapNames.append("seedToSoilMap")
        mapNames.append("soilToFertilizerMap")
        mapNames.append("fertilizerToWaterMap")
        mapNames.append("waterToLightMap")
        mapNames.append("lightToTemperatureMap")
        mapNames.append("temperatureToHumidityMap")
        mapNames.append("humidityToLocationMap")

        // test loop through all lines of struct, printing out the 3 ints
        /* for lineData in temperatureToHumidityMap {
         print("Struct Line: \(lineData.value1), \(lineData.value2), \(lineData.value3)")
         } */


        var sourceNumber = 0 // type: Int
        //        var mapName = "" // type: String
        //        var map = [LineData]() // type: [LineData]
        var destinationNumber = 0 // type: Int
        var seedLoopCounter = 1
        // make variabel called categoryPossibleRowsTemp that is of a type that can hold different string values for all rows in a category that are possible to be the right one
        var mapLoopCounter = 1
        var categoryPossibleRowsTemp = [String]() // type: [String]
        //var categoryPossibleRowsTemp = [LineData]() // type: [LineData] struct
        var rangePosition = 0 // type: Int

        // -------------------------------------------------------------------------------------

        // 1: Get location of first seed (Source = number 2 of line)
        // Print first seed
        /* print("First seed: \(seeds[0])")
         sourceNumber = seeds[0]
         print("Source number: \(seeds[0])") */

        // make big loop for going through all seeds to locations
        for seed in seeds {


            //Step 1
            print("Seed loop counter omgång: \(seedLoopCounter)")
            print("Seed: \(seed)")

            sourceNumber = seed
            // 240126
            //            mapName = "seedToSoilMap" // this must change when next map is used

            // Loop with 7 itterations that updates the locationNr variable so I don't need to store them all. Store the destinationNr in the 7th loop as lowestLocationNr IF destination is lower than lowestLocationNr. 1st itteration of loop 7 just store destination as new lowestLocationNr.
            // Make a loop with 7 iterations
            for x in 0...6 {
                print("'7 loop' entered. On map: \(x) of 0-6")
                mapLoopCounter = 1
                // Call the find destination func with source nr and mapname
                //                destinationNumber = findDestination(sourceNumber: sourceNumber, mapName: mapName, mapDictionary: mapDictionary)
                if x == 0 {
                    //                    destinationNumber = findDestinationNr(sourceNumber, mapName) // instead of mapName take the first key from mapDictionary
                    // instead of mapName take the first key using indexing from mapDictionary
                    destinationNumber = findDestinationNr(sourceNumber, mapNames[x])
                    print("Seed nr: \(seedLoopCounter)\nMap/iteration nr: \(x) from Map: \(mapNames[x]) with SourceNr \(sourceNumber) produced DestinationNr: \(destinationNumber), next Map: \(mapNames[x+1]) shall use it as SourceNr")

                } else {
                    var updatedSource = destinationNumber

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
                    //                    print("Map/iteration nr: \(x) from Map: \(mapNames[x]) with SourceNr \(updatedSource) produced DestinationNr: \(destinationNumber), next Map: \(mapNames[x+1]) shall use it as SourceNr")
                }

                //                destinationNumber = findDestinationNr(sourceNr: <#T##Int#>, mapName: <#T##String#>)

                //                print("Destination number: \(destinationNumber)")
                // Update the sourceNumber variable with the destinationNumber variable
                sourceNumber = destinationNumber
                //print("resetting seedLoopCounter to 1  \n")
                mapLoopCounter = 1
                // Update the mapName variable with the new mapName
                //                mapName = updateMapName(mapName: mapName) //???
                //                print("Map name: \(mapName)")
            }



            //            //Call the find destination func with source nr and mapname
            //            var seedSoilDestination = findDestination(sourceNumber: sourceNumber, mapName: mapName, mapDictionary: mapDictionary)


            // assign the map variable with the value for the key with the mapName in mapDictionary
            //            map = mapDictionary[mapName]!

            // loop through each row in the category
            //            for lineData in seedToSoilMap {
            // ***
            //            for lineData in map {
            //                print("Loop going through lines entered. Linedata: \(lineData)")
            //                // print("Struct Line: \(lineData.value1), \(lineData.value2), \(lineData.value3)")
            //                // print("Struct Line: \(lineData.value1), \(lineData.value2), \(lineData.value3)")
            //                // print("Struct Line: \(lineData.value1), \(lineData.value2), \(lineData.value3)")
            //                // print("Struct Line: \(lineData.value1), \(lineData.value2), \(lineData.value3)")
            //                // print("Struct Line: \(lineData.value1), \(lineData.value2), \(lineData.value3)")
            //                // print("Struct Line: \(lineData.value1), \(lineData.value2), \(lineData.value3)")
            //                // print("Struct Line: \(lineData.value1), \(lineData.value2), \(lineData.value3)")
            //                // print("Struct Line: \(lineData.value1), \(lineData.value2), \(lineData.value3)")
            //                // print("Struct Line: \(lineData.value1), \(lineData.value2), \(lineData.value3)")
            //                // print("Struct Line: \(lineData.value1), \(lineData.value2), \(lineData.value3)")
            //
            //
            //                // Seed is below lowest source number. lineData.value2 is the source number
            //                if sourceNumber < lineData.value2 {
            //                    print("sourceNumber(seed first time) \(sourceNumber) < lineData.value2 \(lineData.value2)")
            //                    print("sourceValue (seed) is below source start number. sourceValue: \(sourceNumber), source start number: \(lineData.value2)")
            //                    // print that write "sourceBelowLowest" into list of categoryPossibleRowsTemp
            //                    print("sourceBelowLowest - write into list of categoryPossibleRowsTemp and go to next row in category")
            //
            //                    // write "sourceBelowLowest" into list of categoryPossibleRowsTemp
            //                    categoryPossibleRowsTemp.append("sourceBelowLowest")
            //                    print("categoryPossibleRowsTemp: \(categoryPossibleRowsTemp)")
            //
            //                    print("sourceValue (seed) is below (source number+range value) and hence out of range this row. Assigning destination as source for now")
            //                    destinationNumber = sourceNumber
            //                    print("destinationNumber: \(destinationNumber)")
            //
            //                } else {
            //                    print("sourceValue (seed) is not below source start number. So check if it's above highest source number (source start nr+range(-1))")
            //
            //                    //Seed is above heighest source nr (source number + (range value-1))
            //                    if sourceNumber > lineData.value2 + lineData.value3 - 1 { //lineData.value3 is the range value
            //                        categoryPossibleRowsTemp.append("sourceAboveHighest")
            //                        print("sourceValue (seed) is above (source number+range value) and hence out of range this row. Assigning destination as source for now")
            //                        destinationNumber = sourceNumber
            //                        print("source number (instead of seed later): \(sourceNumber)")
            //                        print("seed number (instead of soil later): \(seed)")
            //                        print("Destination number: \(destinationNumber)")
            //                        print("Seed/source nr shouuld be same as destination nr")
            //                    } else { // Seed in range
            //                        print("Seed/Source is within range")
            //                        // write "sourceWithinRange" into list of categoryPossibleRowsTemp
            //                        categoryPossibleRowsTemp.append("sourceWithinRange")
            //
            //                        // find rangePosition of source/seed
            //                        rangePosition = sourceNumber - lineData.value2 // lineData.value2 is the source number start
            //                        print("rangePosition: \(rangePosition), lineData.value2: \(lineData.value2)")
            //
            //                        //assign destination number
            //                        destinationNumber = lineData.value1 + rangePosition
            //                        print("destinationNumber: \(destinationNumber)")
            //
            //                        // send to func that takes the destination nr as incoming source nr and does these things again but with source now being soil instead of seed
            //
            //
            //                    }
            //                    /* if seed > lineData.value2 + lineData.value3 {
            //                     print("Seed is above (source number+range value) and hence out of range. Meaning soil is the same number as the seed")
            //                     destinationNumber = seed
            //                     print("source number (instead of seed later): \(sourceNumber)")
            //                     print("seed number (instead of soil later): \(seed)")
            //                     print("Destination number: \(destinationNumber)")
            //                     print("Seed/source nr shouuld be same as destination nr")
            //                     } else {
            //                     print("Seed is within range")
            //                     } */
            //                }
            //
            //                // save seed's soil number, aka the source's destination number
            //                // sourceNumber = seedToSoilMap[0].value2
            //                // print("Source number: \(sourceNumber)")
            //                // print("
            //
            //
            //
            //
            //                //   print("Source start nr (First seed to soil source position): \(seedToSoilMap[0].value2)")
            //
            //                // print first map range value of teh first line
            //                // print("First seed to soil range value: \(seedToSoilMap[0].value3)")
            //
            //
            //                // START HERE 1: add in handling with a func to take source and range for a row and continue returning destination nr. Find out seeds soil nr (below-, withing or above range) for every seed, do you need to look through the entire category map? each line? to look if it fits within any range? or only first row in category.. don't think so since there's not same amount of rows in each category.
            //
            //                print("Avslutar omgång(seedLoopCounter): \(seedLoopCounter), plusar på 1 till counter för nästa loop och går till nästa rad")
            //
            //                seedLoopCounter += 1
            //
            //                //drop all data inside categoryPossibleRowsTemp
            //                categoryPossibleRowsTemp.removeAll()
            //
            //            } //***

            // Check if seed's within source->range value
            // print first map source number
            // print("First seed to soil source position: \(seedToSoilMap[0].value2)")

            // print first map range value of teh first line
            // print("First seed to soil range value: \(seedToSoilMap[0].value3)")

            // print first map source number + range value
            //print("First seed to soil source position + range value: \(seedToSoilMap[0].value2 + seedToSoilMap[0].value3)")
            //3 // what is this three? - it's the range value
            // first check if seed is below source number or above (source number+range value), or within source+range
            //to do rename seed to source and make it work same for all steps - source to find destination nr. make func for it
            //        if seeds[0] < seedToSoilMap[0].value2 {
            //            print("Seed is below source number")
            //            // What if it is? - then it's the same number as the seed - CHECK statement
            //        } else {
            //            print("Seed is not below source number")
            //
            //            //check if seed is above source number + range value
            //            if seeds[0] > seedToSoilMap[0].value2 + seedToSoilMap[0].value3 {
            //                print("Seed is above (source number+range value) and hence out of range. Meaning soil is the same number as the seed")
            //                destinationNumber = seeds[0]
            //                print("source number (instead of seed later): \(sourceNumber)")
            //                print("seed number (instead of soil later): \(seeds[0])")
            //                print("Destination number: \(destinationNumber)")
            //                print("Seed/source nr shouuld be same as destination nr")
            //            } else {
            //                print("Seed is within range")
            //            }
            //        }

            // save seed's soil number, aka the source's destination number



            /// 2-880-930-400 - seed
            ///   47-360-832 - source
            ///  145-454-582 - source+range

            //loop from source number up to source number+range number and check if seed number is within
            /*  for i in seedToSoilMap[0].value2...seedToSoilMap[0].value2+seedToSoilMap[0].value3 {
             // print("i: \(i)")
             //            print("Seed: \(seeds[0])")

             if seeds[0] == i {
             print("Seed is within range")
             }
             } */

            //****** Make func for checking if a value is within a range
            /*         func isValueWithinRange(valueToCheck: Int, source: Int, rangeLength: Int) -> Bool {
             print("isValueWithinRange entered")

             // print("valueToCheck: \(valueToCheck)")
             // print("source: \(source)")
             // print("rangeLength: \(rangeLength)")

             //loop from source number up to source number+range number and check if seed number is within
             for i in rangeStart...rangeStart+rangeLength {
             // print("i: \(i)")
             // print("Seed: \(seeds[0])")

             if value == i {
             // print("Seed is within range")
             return true
             }
             }
             return false
             } */

            // Get location of first seed (Source = number 2 of line )
            /* seedToSoilMap[0].value2 // type: Int -
             print("SeedToSoilMap[0].value2: \(seedToSoilMap[0].value2)")
             */
            seedLoopCounter += 1
        }

        print("\nThe Lowest Location Nr and the output for AoC Day 5 is: \(lowestLocationNr) \nDone")

        // ------------------------- FUNCTIONS----------------------------

        func readFile() -> [String]{
            // Debug: readFile entered
            //            print("readFile entered")

            // Read input file
            //            let path = Bundle.main.path(forResource: "input-mini", ofType: "txt")! // type: String
            let path = Bundle.main.path(forResource: "input", ofType: "txt")! // type: String
            let data = try! String(contentsOfFile: path, encoding: String.Encoding.utf8) // type: String
            let lines = data.components(separatedBy: "\n") // type: [String]

            return lines
        }

        func separateOutSeeds(lines: [String]) -> [Int] { // 9.1 - separateOutSeeds

            // Debug: separateOutSeeds entered
            //            print("separateOutSeeds entered")

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
            // func taking a string and a position in the string where to drop characters until, returning an array of ints

            // Debug: trimStringTurnIntoIntArray entered
            //            print("trimStringTurnIntoIntArray entered")

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

        // Func to take a source nr (eg seed), the range nr from first line of seepmap?, return destination nr (eg soil)

        // Make func that takes a source nr int and a map name as a string eg. soilToFertilizerMap and returns a destination nr.
        func findDestinationNr(_ sourceNr: Int, _ mapName: String) -> Int {
            // Debug: findDestinationNr entered
            //            print("findDestinationNr entered with sourceNr: \(sourceNr) and mapName: \(mapName)")
            print("SourceNr: \(sourceNr), mapName: \(mapName)")

            // Populate the map linedata
            //            var map = mapDictionary(key: mapName)
            let mapLinedata = mapDictionary[mapName]

            for lineData in mapLinedata! {
                // print("Loop going through lines entered. Linedata: \(lineData)")
                print(lineData)
                // Source is below lowest source number. lineData.value2 is the source number
                if sourceNr < lineData.value2 {
                    //  print("SourceNumber \(sourceNr) < lineData.value2 \(lineData.value2)")
                    print("SourceNumber \(sourceNr) is below source start number (\(lineData.value2)) for this line of \(mapName). Assigning destination as source for now and checking if more lines")
                    // print that write "sourceBelowLowest" into list of categoryPossibleRowsTemp
                    //  print("sourceBelowLowest - write into list of categoryPossibleRowsTemp and go to next row in category")

                    // write "sourceBelowLowest" into list of categoryPossibleRowsTemp
                    categoryPossibleRowsTemp.append("sourceBelowLowest")
                    //    print("categoryPossibleRowsTemp: \(categoryPossibleRowsTemp)")

                    //                    print("sourceValue (seed) is below (source number+range value) and hence out of range this row. Assigning destination as source for now")
                    destinationNumber = sourceNr
                    print("destinationNumber: \(destinationNumber)")

                } else {
                    //                    print("sourceValue (\(sourceNr) is not below source start number (\(lineData.value2)). So check if it's above highest source number (source start nr+range(-1))")

                    print("sourceValue (\(sourceNr))")

                    //Seed is above heighest source nr (source number + (range value-1))
                    if sourceNr > lineData.value2 + lineData.value3 - 1 { //lineData.value3 is the range value
                        categoryPossibleRowsTemp.append("sourceAboveHighest")
                        print("sourceValue is above (source number+range value) and hence out of range this row. Assigning destination as source for now")
                        destinationNumber = sourceNr
                        print("source number: \(sourceNr)")
                        //                        print("seed number (instead of soil later): \(seed)")
                        print("Destination number: \(destinationNumber)")
                        print("Source nr should be same as destination nr")
                    } else { // Seed in range
                        print("Source is within range")
                        // write "sourceWithinRange" into list of categoryPossibleRowsTemp
                        categoryPossibleRowsTemp.append("sourceWithinRange")

                        // find rangePosition of source/seed
                        rangePosition = sourceNr - lineData.value2 // lineData.value2 is the source number start
                        //                        print("rangePosition: \(rangePosition), lineData.value2: \(lineData.value2)")

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
