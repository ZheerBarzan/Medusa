//
//  AppDataModel+Orbit.swift
//  Medusa
//
//  Created by zheer barzan on 31/1/25.
//

// We are adding new stuff to AppDataModel
extension AppDataModel{
    // We are creating a new group of things called Orbit
    enum Orbit: Int, CaseIterable, Identifiable, Comparable{
        // These are the different orbits we have
        case Orbit1, Orbit2, Orbit3
        
        // This gives each orbit a unique number
        var id: Int {
            return rawValue
        }
        // This gives each orbit a picture name
        var image: String{
            let imagebyOrbit = ["1.circle", "2.circle", "3.circle"]
            return imagebyOrbit[rawValue]
        }
        
        // This gives each orbit a selected picture name
        var imageSelected: String{
            let imagebyOrbit = ["1.circle.fill", "2.circle.fill", "3.circle.fill"]
            return imagebyOrbit[rawValue]
        }
        
        // This function gives the next orbit
        func next() -> Self{
            guard let currentIndex = Self.allCases.firstIndex(of: self) else {
                fatalError("Unknown orbit")
            }
            // Find the next position in the list of orbits and return the last orbit if there is no next orbit
            let nextIndex = Self.allCases.index(after: currentIndex)
            return Self.allCases[nextIndex == Self.allCases.endIndex ? Self.allCases.endIndex - 1 : nextIndex]
        }
        
        // This function compares two orbits to see which comes first
        static func < (leftHandSide: AppDataModel.Orbit, rightHandSide: AppDataModel.Orbit) -> Bool {
            guard let leftIndex = Self.allCases.firstIndex(of: leftHandSide),
                  let rightIndex = Self.allCases.firstIndex(of: rightHandSide) else {
                return false
            }
            // Return true if the first orbit comes before the second one
            return leftIndex < rightIndex
        }
    }
}
