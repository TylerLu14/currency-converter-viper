//
//  Scheduler.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/6/21.
//

//import RxCocoa
//import RxSwift
//
//let scheduler = Scheduler.sharedScheduler
//
//class Scheduler {
//    public static let sharedScheduler = Scheduler()
//
//    let main = MainScheduler.instance
//    let concurrentMain = ConcurrentMainScheduler.instance
//
//    let serialBackground = SerialDispatchQueueScheduler(qos: .background)
//    let concurrentBackground = ConcurrentDispatchQueueScheduler(qos: .background)
//
//    let serialUtility = SerialDispatchQueueScheduler(qos: .utility)
//    let concurrentUtility = ConcurrentDispatchQueueScheduler(qos: .utility)
//
//    let serialUser = SerialDispatchQueueScheduler(qos: .userInitiated)
//    let concurrentUser = ConcurrentDispatchQueueScheduler(qos: .userInitiated)
//
//    let serialInteractive = SerialDispatchQueueScheduler(qos: .userInteractive)
//    let concurrentInteractive = ConcurrentDispatchQueueScheduler(qos: .userInteractive)
//
//    let operationalScheduler: ImmediateSchedulerType = {
//        let operationQueue = OperationQueue()
//        operationQueue.maxConcurrentOperationCount = 10
//        operationQueue.qualityOfService = QualityOfService.userInitiated
//        return OperationQueueScheduler(operationQueue: operationQueue)
//    }()
//}

