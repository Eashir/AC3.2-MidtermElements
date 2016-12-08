//
//  Element.swift
//  AC3.2-MidtermElements
//
//  Created by Eashir Arafat on 12/8/16.
//  Copyright © 2016 Evan. All rights reserved.
//

import Foundation

enum elementParseError: Error {
    case response, name, number, symbol, weight, meltingPoint, boilingPoint
}

class Element {
    let name: String
    let number: Int
    let symbol: String
    let weight: Float
    let meltingPoint: Int
    let boilingPoint: Int
    init(name: String, number: Int, symbol: String, weight: Float, meltingPoint: Int, boilingPoint: Int) {
        self.name = name
        self.number = number
        self.symbol = symbol
        self.weight = weight
        self.meltingPoint = meltingPoint
        self.boilingPoint = boilingPoint
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
                        let boilingPoint = "Null"
                        break
                }
                
                let validElement = Element(name: name,number: number, symbol: symbol, weight: weight, meltingPoint: meltingPoint, boilingPoint: boilingPoint)
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
