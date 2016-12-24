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

public protocol MeasureLoggerType: class {
  func didEndMeasurement(result: Measure.Result)
}

open class Measure: Hashable {

  public struct Result {
    public let name: String
    public let startAt: Date
    public let endAt: Date
    public let time: TimeInterval
    public let threshold: TimeInterval?
    public let isThresholdExceeded: Bool

    public let file: String
    public let function: String
    public let line: UInt
  }

  public static func == (lhs: Measure, rhs: Measure) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }

  public var hashValue: Int {
    return ObjectIdentifier(self).hashValue ^ name.hashValue
  }

  // MARK: - Properties

  open static var defaultLogger: MeasureLoggerType?

  open var logger: MeasureLoggerType? = Measure.defaultLogger

  open let name: String

  open var threshold: TimeInterval?

  open var startAt: Date?

  open var endAt: Date?

  public let file: String
  public let function: String
  public let line: UInt

  // MARK: - Initializers

  public required init(name: String, threshold: TimeInterval? = nil, file: String = #file, function: String = #function, line: UInt = #line) {

    self.name = name
    self.threshold = threshold
    self.file = file
    self.function = function
    self.line = line
  }

  @discardableResult
  open func start() -> Measure {

    startAt = Date()
    return self
  }

  @discardableResult
  open func end() -> Result {

    let _endAt = Date()

    guard let startAt = startAt else {
      assertionFailure("Measurement has not begun, please call start()")
      return Result(
        name: name + " :: Measurement has not begun, please call start()",
        startAt: Date(),
        endAt: Date(),
        time: 0,
        threshold: nil,
        isThresholdExceeded: false,
        file: file,
        function: function,
        line: line
      )
    }

    endAt = _endAt

    let time = _endAt.timeIntervalSinceReferenceDate - startAt.timeIntervalSinceReferenceDate

    let isThresholdExceeded: Bool

    if let t = threshold, time > t {
      isThresholdExceeded = true
    } else {
      isThresholdExceeded = false
    }

    return Result(
      name: name,
      startAt: startAt,
      endAt: _endAt,
      time: time,
      threshold: threshold,
      isThresholdExceeded: isThresholdExceeded,
      file: file,
      function: function,
      line: line
    )
  }

  @discardableResult
  open func reset() -> Self {
    startAt = nil
    endAt = nil
    return self
  }

  open class func run(name: String, threshold: TimeInterval, block: () -> Void) -> Result {

    let measure = self.init(name: name, threshold: threshold)
    measure.start()
    block()
    return measure.end()
  }
}
