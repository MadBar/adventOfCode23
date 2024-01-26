//
//  ViewController.swift
//  AoC23-5a
//
//  Created by Madeleine Barwén on 2023-12-05.
//
/// The Gardener/Farmer:
/// What is the lowest location number that corresponds to any of the initial seed numbers?
///
/// (Can't make water/snow - Rand out of sand to filter water with)
///
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
/// seed-to-soil map eg.:
/// .50 98 2
/// (52 50 48)
///
/// MAP MEANS:
/// - DESTINATION range starts at 50 and contains TWO values: 50 and 51:
///     - Seed 50
/// - SOURCE range starts at 98 and contains TWO values: 98 and 99
///    - Soil 98
///
/// seed  soil ---- what is this matrix?
/// 0     0
/// 1     1
/// ...   ...
/// 48    48
/// 49    49
/// 50    52
/// 51    53
/// ...   ...
/// 96    98
/// 97    99
/// 98    50
/// 99    51
///
/// Seed and soild examples:
///  Seed number 79 corresponds to soil number 81.
///     - 96 known seed -79current seed = 17 - to find ratio to apply to find destination
///     - 98-17= 81
///  Seed number 14 corresponds to soil number 14.
///  Seed number 55 corresponds to soil number 57
///  Seed number 13 corresponds to soil number 13
///
/// 1. What's closest location/LOWEST LOCATION NR needing a seed?
///     - convert each seed number through other categories until you can find its corresponding location number
///
///10:
///  seed-to-soil map:
///  50 98 2
///  52 50 48
///     seed 79 is withing range of 50+48 (98), so it's soil will be +2.
///     soil 81 is not within ranges, so should be same value
///     fert 81 is not in range so same
///     water-to: 81  has relationship -7, 81-7=74
///     light 74, within relation +4, 74+4=78
///     temperature 78 no relation, so same
///     humidity 78 relation: +4 = 82
/// Seed 79, soil 81, fertilizer 81, 81 water , 74 light , 78 temperature , 78 humidity , location : 82
/// Seed 14, soil , fertilizer , water , light , temperature , humidity , location :
/// Seed 55, soil , fertilizer , water , light , temperature , humidity , location :
/// Seed 13, soil , fertilizer , water , light , temperature , humidity , location :
/// seed 2880930400, soil 2880930400, fertilizer , water , light , temperature , humidity , location :

///
/// Questions before starting:
/// 1. Is the length of source and destination always the same for a row?  (now between different rows)
/// 2. What is the matrix above?
/// 3. How have they calculated the seed and soil examples?
/// 4. Understand how to work the examples above to find location
///

import Foundation


///
///Garden / farmer
//
//1: DONE
//Declare global variables
//    var lowestLocationNr
//    var allLocations
///
///
//9:
//Functions for prepping the input file:
/// 9.1 - separateOutSeeds
/// 9.2 - separateOutSeedToSoilMap
/// 9.3- separateOutSoilToFertilizerMap
/// 9.4- separateOutFertilizerToWaterMap
/// 9.5- separateOutWaterToLightMap
/// 9.6- separateOutLightToTemperatureMap
/// 9.7 separateOutTemperatureToHumidityMap
/// 9.8 separateOutHumidityToLocationMap
//
//Separate out into types - struct maybe!???
// 9.1  Seeds
///

//2. seed-to-soil map:
//3. soil-to-fertilizer map:
//4. fertilizer-to-water
//5. water-to-light
//6. light-to-temperature
//7. temperature-to-humidity
//8. humidity-to-location
//
//10:
//“Follow Chain from seed to location
//
//    Step 1:
//    for seed in allSeeds
//        // no: if let var seed = allSeeds[seed] // eg. 79 // unnecessary? Just use seed
//
//        var source // initially SEED
//        var destination // initially SOIL 
//        // with seed - look through
//
//    Go line by line in input data
//
//15
//Func addToAllLocations
//Add/append location to allLocations
//
//18
//Func findLowestLocation
//Find lowestLocationNr by looking through collection of all locationNrs (no reference to their seeds needed)
//
//30
//Print lowestLocationNr

///
///
