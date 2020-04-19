//
//  ArrowModel.swift
//  FlankerExamination
//
//  Created by Daniel James on 12/7/19.
//  Copyright © 2019 Dom.Inspiration. All rights reserved.
//

import Foundation

//our arrow manager class is where the "magic happens"
//we define the arrows within an arrow tuple giving them known values for congruency, direction and string value from an enum
//when arrow.description is called for a case we increment the count using a computed property
//this could be upgraded using NSCountedSet perhaps to completely avoid the computed prop

class ArrowManager{
    
    let arrowTuple = [(arrow: Arrow.leftCongruent, congruent: 1, isLeft: 1),
                     (arrow: Arrow.leftIncongruent, congruent: 0, isLeft: 1),
                     (arrow: Arrow.rightCongruent, congruent: 1, isLeft: 0),
                     (arrow: Arrow.rightIncongruent, congruent: 0, isLeft: 0)]
 
        static var leftCongruentCount = 0
        static var rightCongruentCount = 0
        static var leftIncongruentCount = 0
        static var rightIncongruentCount = 0


    enum Arrow: String, CaseIterable{
        case leftCongruent = "<<<<<"
        case rightCongruent = ">>>>>"
        case leftIncongruent = ">><>>"
        case rightIncongruent = "<<><<"
        
        

        var description: Int? {
            
            switch self {

            case .leftCongruent:
                ArrowManager.leftCongruentCount += 1
                return ArrowManager.leftCongruentCount

            case .rightCongruent:
                ArrowManager.rightCongruentCount += 1
                return ArrowManager.rightCongruentCount

            case .leftIncongruent:
                ArrowManager.leftIncongruentCount += 1
                return ArrowManager.leftIncongruentCount
                
            default:
                ArrowManager.rightIncongruentCount += 1
                return ArrowManager.rightIncongruentCount
            }
        }
    }
    
    //reset all values at deinitializaion - aka when reference is set to nil
    deinit {
        ArrowManager.leftCongruentCount = 0
        ArrowManager.rightCongruentCount = 0
        ArrowManager.leftIncongruentCount = 0
        ArrowManager.rightIncongruentCount = 0
    }
    
    func presentArrow() -> (String, Int, Int) {
        var arrowShown: String?
        var isCongruent: Int?
        var isLeft: Int?
        
        //choose a random arrow
        //enumerated returns the int postion and the value arrow
        let arrowChosen = arrowTuple.enumerated().map {($0)}.randomElement()
        let indexChosen = arrowChosen?.offset
        //unwrap the count and prompt the computed value to increment the arrow
        //selected - or return no arrow
        guard let arrowCount = arrowChosen?.element.arrow.description else {return ("no arrow", 9, 9)}
        //if the count of arrow is less than or equal to 5 then allow it to display
        if arrowCount <= 5 {
        //assign arrow to be shown
            arrowShown = arrowChosen?.element.arrow.rawValue
            isCongruent = arrowTuple[indexChosen!].congruent
            isLeft = arrowTuple[indexChosen!].isLeft
        } else {
        //recursively call our function to produce a new random value with less than 5 screen showings
            let newArrowShown = presentArrow()
            arrowShown = newArrowShown.0
            isCongruent = newArrowShown.1
            isLeft = newArrowShown.2
        }
        return (arrowShown!, isCongruent!, isLeft!)
    }
}

