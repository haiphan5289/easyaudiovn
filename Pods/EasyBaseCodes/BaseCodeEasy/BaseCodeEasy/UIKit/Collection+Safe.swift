//
//  Collection+Safe.swift
//  CTCommon
//
//  Created by Nguyen Hung on 4/19/21.
//

import Foundation

public extension Collection {

    var safe: SafeCollection<Self> {
        return SafeCollection(self)
    }
}

public struct SafeCollection<Base: Collection> {
    
    private var _base: Base
    public init(_ base: Base) {
        _base = base
    }
    
    private func distance(from startIndex: Base.Index) -> Int {
        return _base.distance(from: startIndex, to: _base.endIndex)
    }
    
    private func distance(to endIndex: Base.Index) -> Int {
        return _base.distance(from: _base.startIndex, to: endIndex)
    }
    
    public subscript(index: Base.Index) -> Base.Iterator.Element? {
        if distance(to: index) >= 0 && distance(from: index) > 0 {
            return _base[index]
        }
        return nil
    }
    
    public subscript(bounds: Range<Base.Index>) -> Base.SubSequence? {
        if distance(to: bounds.lowerBound) >= 0 && distance(from: bounds.upperBound) >= 0 {
            return _base[bounds]
        }
        return nil
    }
    
    public subscript(bounds: ClosedRange<Base.Index>) -> Base.SubSequence? {
        if distance(to: bounds.lowerBound) >= 0 && distance(from: bounds.upperBound) > 0 {
            return _base[bounds]
        }
        return nil
    }
}
