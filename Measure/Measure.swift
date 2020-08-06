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

public struct MeasureStartPost: Hashable {

  // MARK: - Properties

  public let name: String

  public let threshold: TimeInterval?

  private(set) public var startedAt: TimeInterval?

  public let metadata: MeasureMetadata

  // MARK: - Initializers

  public init(name: String, threshold: TimeInterval? = nil, file: String = #file, function: String = #function, line: UInt = #line) {

    self.name = name
    self.threshold = threshold
    self.metadata = MeasureMetadata(file: file, function: function, line: line)
  }

  public func start() -> MeasureStartPost {

    var _self = self
    _self.startedAt = CACurrentMediaTime()
    return _self
  }

  public func end(label: String? = nil, file: String = #file, function: String = #function, line: UInt = #line) -> MeasureEndPost {

    let _endAt = CACurrentMediaTime()

    let endPostMetadata = MeasureMetadata(file: file, function: function, line: line)

    guard let startAt = startedAt else {
      assertionFailure("Measurement has not begun, please call start()")
      return MeasureEndPost(
        name: name + " :: Measurement has not begun, please call start()",
        endLabel: label,
        startAt: TimeInterval(),
        endAt: TimeInterval(),
        time: 0,
        threshold: nil,
        isThresholdExceeded: false,
        startPostMetadata: metadata,
        endPostMetadata: endPostMetadata
      )
    }

    let time = _endAt - startAt

    let isThresholdExceeded: Bool

    if let t = threshold, time > t {
      isThresholdExceeded = true
    } else {
      isThresholdExceeded = false
    }

    let result = MeasureEndPost(
      name: name,
      endLabel: label,
      startAt: startAt,
      endAt: _endAt,
      time: time,
      threshold: threshold,
      isThresholdExceeded: isThresholdExceeded,
      startPostMetadata: metadata,
      endPostMetadata: endPostMetadata
    )

    return result
  }

}

public struct MeasureMetadata: Hashable {
  public let file: String
  public let function: String
  public let line: UInt
}

public struct MeasureEndPost: CustomStringConvertible {

  public let name: String
  public let endLabel: String?
  public let startAt: TimeInterval
  public let endAt: TimeInterval
  public let time: TimeInterval
  public let threshold: TimeInterval?
  public let isThresholdExceeded: Bool

  public let startPostMetadata: MeasureMetadata
  public let endPostMetadata: MeasureMetadata

  public func print() {

    Swift.print(
      renderResultText()
    )
  }

  public var description: String {
    renderResultText()
  }

  private func renderResultText() -> String {
    return """
      ⏱ [Measure] \(name)
      ⇤ \(String(startPostMetadata.file.suffix(40))):\(startPostMetadata.line)
      ⇥ \(String(endPostMetadata.file.suffix(40))):\(endPostMetadata.line) \(endLabel ?? "")
      ↳ \(time * 1000) ms \(isThresholdExceeded ? "⚠️" : "✅")
      """
  }
}
