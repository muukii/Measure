// Measure.swift
//
// Copyright (c) 2016 muukii
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

public struct Measure {
    
    // MARK: - Public
    
    public let name: String
    
    public let threshold: NSTimeInterval?
    
    public var time: NSTimeInterval {
        
        return endAt.timeIntervalSince1970 - startAt.timeIntervalSince1970
    }
    
    public init(name: String, threshold: NSTimeInterval? = nil) {
        
        self.name = name
        self.threshold = threshold
    }
    
    public mutating func start() -> Measure {
        
        startAt = NSDate()
        return self
    }
    
    public mutating func end() -> Measure {
        
        self.endAt = NSDate()
        
        let warning: String
        if time > threshold {
            warning = ("[😱Exceeded threshold]")
        }
        else {
            warning = ""
        }
        
        Measure.log("\(name) : \(time) sec \(warning)")
        
        return self
    }
    
    public static func run(name name: String, threshold: NSTimeInterval, @noescape block: () -> Void) -> Measure {
        
        var measure = Measure(name: name, threshold: threshold)
        measure.start()
        block()
        measure.end()
        
        return measure
    }
    
    // MARK: - Private
    
    private var startAt: NSDate = NSDate(timeIntervalSince1970: 0)
    private var endAt: NSDate = NSDate(timeIntervalSince1970: 0)
    
    private static func log(text: String) {
        
        print("[Measure] -> \(text)")
    }
}
