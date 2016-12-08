//
//  Element.swift
//  AC3.2-MidtermElements
//
//  Created by Eashir Arafat on 12/8/16.
//  Copyright © 2016 Evan. All rights reserved.
//
import Foundation
import UIKit

enum elementParseError: Error {
    case response, name, number, symbol, weight, meltingPoint, boilingPoint, density, crust, discoveryYear, electrons
}

class Element {
    let name: String
    let number: Int
    let symbol: String
    let weight: Float
    let meltingPoint: Int
    let boilingPoint: Int
    let uiColor: UIColor
    let density: Double
    let electrons: String
    
    
    let discoveryYear: String
    
    /*
     "density": 0.09,
     "crust_percent": 0.14,
     "discovery_year": "1776",
     "group": 1,
     "electrons": "1s1",
     "ion_energy": 13.5984
     },
     */
    
    init(electrons: String, name: String, number: Int, symbol: String, weight: Float, meltingPoint: Int, boilingPoint: Int,   discoveryYear: String, uiColor: UIColor, density: Double) {
        self.electrons = electrons
        self.name = name
        self.number = number
        self.symbol = symbol
        self.weight = weight
        self.meltingPoint = meltingPoint
        self.boilingPoint = boilingPoint
        self.uiColor = uiColor
        self.density = density
        
        
        self.discoveryYear = discoveryYear
        
    }
    
    static func getElements(from data: Data?) -> [Element]? {
        var elements: [Element]? = []
        
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data!, options: [])
            
            guard let response = jsonData as? [[String: Any]]
                else { throw elementParseError.response }
            
            for element in response {
                
                guard let name = element["name"] as? String
                    else { throw elementParseError.name }
                guard let number = element["number"] as? Int
                    else { throw elementParseError.number }
                guard let symbol = element["symbol"] as? String
                    else { throw elementParseError.symbol }
                guard let weight = element["weight"] as? Float
                    else { throw elementParseError.weight }
                guard let meltingPoint = element["melting_c"] as? Int
                    else { throw elementParseError.meltingPoint }
                guard let boilingPoint = element["boiling_c"] as? Int
                    else {
                        let boilingPoint = 0
                        break
                }
                
                guard let discoveryYear = element["discovery_year"] as? String
                    else {
                        throw elementParseError.discoveryYear
                }
                
                guard  let density = element["density"] as? Double
                    else {
                        let density = 0.0
                        break
                }
                guard let electrons = element["electrons"] as? String
                    else { throw elementParseError.electrons }
                
                
                        let validElement = Element(electrons: electrons, name: name,number: number, symbol: symbol, weight: weight, meltingPoint: meltingPoint, boilingPoint: boilingPoint, discoveryYear: discoveryYear, uiColor: UIColor(red:0.043, green:0.576 ,blue:0.588 , alpha:1.0), density: density)
                elements?.append(validElement)
            }
            return elements
            
        }
        catch {
            print("Problem casting json: \(error)")
        }
        
        
        return nil
    }
    
}
