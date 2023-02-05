//
//  Dynamic.swift
//  NewsApp
//
//  Created by Alexandra Shurpeleva on 5.02.23.
//

class Dynamic<Value> {
    typealias Listener = (Value) -> ()
    var listener: Listener?
    
    init(_ value: Value) {
        self.value = value
    }
    
    var value: Value {
        didSet {
            listener?(value)
        }
    }
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
