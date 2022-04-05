//
//  AsyncOperation.swift
//  
//
//  Created by Chris Scalcucci on 3/21/22.
//

import Foundation

public typealias AsyncCompletion = ((AsyncOperation.State) -> Void)

open class AsyncOperation: Operation {
    public typealias StateOperationBlock = (@escaping (AsyncOperation.State) -> Void) -> Void

    public enum State: String {
        case ready, executing, finished

        fileprivate var keyPath: String {
            "is\(rawValue.capitalized)"
        }
    }

    public var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }

    public override var isExecuting: Bool {
        state == .executing
    }

    public override var isFinished: Bool {
        state == .finished
    }

    public override var isAsynchronous: Bool {
        true
    }

    public override func start() {
        guard !isCancelled else {
            state = .finished
            return
        }
        state = .executing
        main()
    }

    public override func cancel() {
        state = .finished
    }

    open var block: StateOperationBlock = { (asyncBlock: @escaping (AsyncOperation.State) -> Void) in }

    public init(block: @escaping StateOperationBlock) {
        self.block = block
        super.init()
    }

    public override init() {
        super.init()
    }

    public override func main() {
        self.block({ [weak self] state in
            guard let self = self else { return }
            self.state = state
        })
    }
}
