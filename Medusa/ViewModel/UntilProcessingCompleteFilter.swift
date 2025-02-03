//
//  UntilProcessingCompleteFilter.swift
//  Medusa
//
//  Created by zheer barzan on 3/2/25.
//

import SwiftUI
import RealityKit

struct UntilProcessingCompleteFilter<Base>: AsyncSequence, AsyncIteratorProtocol where Base: AsyncSequence, Base.Element == PhotogrammetrySession.Output{
    
    func makeAsyncIterator() -> UntilProcessingCompleteFilter {
        return self
    }
    
    typealias AsyncIterator = Self
    typealias Element = PhotogrammetrySession.Output
    
    private let inputSequence: Base
    private var isComplete:Bool = false
    private var iterator: Base.AsyncIterator
    
    init(input: Base) where Base.Element == Element{
        
        inputSequence = input
        iterator = inputSequence.makeAsyncIterator()
    }
    
    mutating func next() async -> Element?{
        if isComplete{
            return nil
        }
        
        guard let element = try? await iterator.next() else {
            isComplete = true
            return nil
        }
        
        if case Element.processingComplete = element{
            isComplete = true
        }
        
        if case Element.processingCancelled = element{
            isComplete = true
        }
        
        return element
    }
}
