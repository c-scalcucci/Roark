//
//  RKViewModel.swift
//  
//
//  Created by Chris Scalcucci on 1/14/21.
//

import Foundation
import RxSwift
import RxCocoa
import Differentiator

open class RKViewModel : ViewModel, IdentifiableType, Equatable, Hashable {
    public typealias Identity = Int

    public internal(set) var identity : Int = UUID().hashValue

    public private(set) var disposeBag = DisposeBag()

    private lazy var operationQueue : OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    @inlinable public static func ==(lhs: RKViewModel, rhs: RKViewModel) -> Bool {
        return lhs.identity == rhs.identity
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(identity)
    }

    public func setQueueName(_ queueName: String) {
        let operation = AsyncOperation { (asyncOperation: @escaping (AsyncOperation.State) -> Void) in
            Thread.current.name = queueName
            asyncOperation(.finished)
        }
        operation.name = "Set Thread Name"
        operationQueue.addOperation(operation)
    }

    //
    // MARK: Updates
    //

    public func cancelAllOperations() {
        operationQueue.cancelAllOperations()
    }

    public func executeInSerialContext(_ asyncCompletion: AsyncCompletion? = nil,
                                       _ name: String? = nil,
                                       _ execute: @escaping (@escaping AsyncCompletion) -> ()) {
        if let asyncCompletion = asyncCompletion {
            execute(asyncCompletion)
        } else {
            let operation = AsyncOperation { (asyncOperation: @escaping (AsyncOperation.State) -> Void) in
                execute(asyncOperation)
            }
            operation.name = name ?? "Unknown"
            operationQueue.addOperation(operation)
        }
    }
}
