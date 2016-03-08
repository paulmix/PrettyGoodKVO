//
//  ObservationRequestsTests.swift
//  PEM-PrettyGoodKVO
//
//  Created by Paul Mix on 3/7/16.
//
//

import XCTest
@testable import PrettyGoodKVO

let defaultClosure: PGKVOObservationClosure = { _, _, _ in }

class ObservationRequestsTests: XCTestCase {
    
    var requests: ObservationRequests!
    var client: NSObject!
    var client2: NSObject!
    
    override func setUp() {
        super.setUp()
        client = NSObject()
        client2 = NSObject()
        requests = ObservationRequests()
    }
    
    override func tearDown() {
        requests = nil
        client = nil
        client2 = nil
        super.tearDown()
    }
}

class ObservationRequestsTests_OneRequest: ObservationRequestsTests {
    
    var addObserverBlockDidFire = false
    
    override func setUp() {
        super.setUp()
        requests.addForClient(client, keyPath: "kp0", options: [.New], closure: defaultClosure, observationBlock: { addObserverBlockDidFire = true } )
    }
}

class ObservationRequestsTests_OneRequestTests: ObservationRequestsTests_OneRequest {

    func testAddingFirstRequest_shouldFireObservationBlock() {
        XCTAssertTrue(addObserverBlockDidFire)
    }
    
    func testAddingFirstRequest_shouldReturnOneRequestForMatchingObservation() {
        let reqs = requests.requestsForKeyPath("kp0", changeKeys: [NSKeyValueChangeNewKey])
        XCTAssertEqual(reqs.count, 1)
    }
    
    func testAddingFirstRequest_shouldReturnNoRequestsForMismatchingObservation() {
        let reqs = requests.requestsForKeyPath("kp0", changeKeys: [NSKeyValueChangeOldKey])
        XCTAssertEqual(reqs.count, 0)
    }
    
}

class ObservationRequestsTests_AnotherRequest: ObservationRequestsTests_OneRequest {
    
    var addObserverBlockDidFireAgain = false
    
    override func setUp() {
        super.setUp()
        requests.addForClient(client2, keyPath: "kp0", options: [.New], closure: defaultClosure, observationBlock: { addObserverBlockDidFireAgain = true } )
    }
}

class ObservationRequestsTests_AnotherRequestTests: ObservationRequestsTests_AnotherRequest {

    func testAddingSecondRequest_shouldNotFireObservationBlock() {
        XCTAssertFalse(addObserverBlockDidFireAgain)
    }
    
    func testAddingSecondRequest_shouldReturnOneKeyPathToRemove() {
        XCTAssertEqual(requests.allKeyPaths.count, 1)
    }
    
    func testAddingSecondRequest_shouldReturnTwoRequestsForMatchingObservation() {
        let reqs = requests.requestsForKeyPath("kp0", changeKeys: [NSKeyValueChangeNewKey])
        XCTAssertEqual(reqs.count, 2)
    }
    
    func testAddingSecondRequest_shouldReturnNoRequestsForMismatchingObservation() {
        let reqs = requests.requestsForKeyPath("kp0", changeKeys: [NSKeyValueChangeOldKey])
        XCTAssertEqual(reqs.count, 0)
    }
}

class ObservationRequestsTests_AnotherRequestSecondClient: ObservationRequestsTests_AnotherRequest {
    
    override func setUp() {
        super.setUp()
        client2 = nil
    }
}

class ObservationRequestsTests_AnotherRequestSecondClientTests: ObservationRequestsTests_AnotherRequestSecondClient {

    func testNilifyingSecondClient_shouldStillHaveOneKeyPath() {
        XCTAssertEqual(requests.allKeyPaths.count, 1)
    }
    
    func testNilifyingSecondClient_shouldReturnTwoRequestsForMatchingObservation() {
        let reqs = requests.requestsForKeyPath("kp0", changeKeys: [NSKeyValueChangeNewKey])
        XCTAssertEqual(reqs.count, 2)
    }
    
    func testNilifyingSecondClient_shouldReturnOneRequestForNilClient() {
        let nilReqs = requests.requestsForKeyPath("kp0", changeKeys: [NSKeyValueChangeNewKey]).filter { $0.client.isNilClient }
        XCTAssertEqual(nilReqs.count, 1)
    }
}

class ObservationRequestsTests_AnotherRequestSecondClientRemovedKeyPathsTests: ObservationRequestsTests_AnotherRequestSecondClient {
    
    var keypathsToRemove = Set<String>()
    
    override func setUp() {
        super.setUp()
        keypathsToRemove = requests.dropNilClients()
    }
    
    func testNilifyingSecondClient_shouldReturnNoKeyPathToRemove() {
        XCTAssertEqual(keypathsToRemove.count, 0)
    }
    
    func testNilifyingSecondClient_shouldContinueObservingOneKeyPath() {
        XCTAssertEqual(requests.allKeyPaths.count, 1)
    }
    
    func testNilifyingSecondClient_shouldReturnOneRequestForMatchingObservation() {
        let reqs = requests.requestsForKeyPath("kp0", changeKeys: [NSKeyValueChangeNewKey])
        XCTAssertEqual(reqs.count, 1)
    }
}

class ObservationRequestsTests_NillifyingBothClients: ObservationRequestsTests_AnotherRequestSecondClient {
    
    override func setUp() {
        super.setUp()
        client = nil
        client2 = nil
    }
}

class ObservationRequestsTests_NillifyingBothClientsTests: ObservationRequestsTests_NillifyingBothClients {
    
    func testNilifyingBothClients_shouldStillHaveOneKeyPath() {
        XCTAssertEqual(requests.allKeyPaths.count, 1)
    }
    
    func testNilifyingBothClients_shouldReturnTwoRequestsForMatchingObservation() {
        let reqs = requests.requestsForKeyPath("kp0", changeKeys: [NSKeyValueChangeNewKey])
        XCTAssertEqual(reqs.count, 2)
    }
    
    func testNilifyingBothClients_bothMatchingRequestsShouldHaveNilClient() {
        let nilReqs = requests.requestsForKeyPath("kp0", changeKeys: [NSKeyValueChangeNewKey]).filter { $0.client.isNilClient }
        XCTAssertEqual(nilReqs.count, 2)
    }
}

class ObservationRequestsTests_NillifyingBothClientsRemovedKeypathsTests: ObservationRequestsTests_NillifyingBothClients {
    
    var keypathsToRemove = Set<String>()
    
    override func setUp() {
        super.setUp()
        keypathsToRemove = requests.dropNilClients()
    }
    
    func testNilifyingBothClients_shouldReturnOneKeyPathToRemove() {
        XCTAssertEqual(keypathsToRemove.count, 1)
    }
    
    func testNilifyingBothClients_shouldReportNoKeyPathsBeingObserved() {
        XCTAssertEqual(requests.allKeyPaths.count, 0)
    }
}


class ObservationRequestsTests_AnotherRequestDifferentOptions: ObservationRequestsTests_OneRequest {
    
    var addObserverBlockDidFireAgain = false
    
    override func setUp() {
        super.setUp()
        requests.addForClient(client, keyPath: "kp0", options: [.Old], closure: defaultClosure, observationBlock: { addObserverBlockDidFireAgain = true } )
    }
    
    func testAddingRequestWithDifferentOptions_shouldFireAddObserverBlock() {
        XCTAssertTrue(addObserverBlockDidFireAgain)
    }
    
    func testAddingRequestWithDifferentOptions_shouldReturnOneKeyPathToRemove() {
        XCTAssertEqual(requests.allKeyPaths.count, 1)
    }
    
    func testAddingRequestWithDifferentOptions_shouldReturnOneRequestForMatchingObservation() {
        let reqsA = requests.requestsForKeyPath("kp0", changeKeys: [NSKeyValueChangeNewKey])
        XCTAssertEqual(reqsA.count, 1)
        
        let reqsB = requests.requestsForKeyPath("kp0", changeKeys: [NSKeyValueChangeOldKey])
        XCTAssertEqual(reqsB.count, 1)
    }
    
    func testAddingRequestWithDifferentOptions_shouldReturnTwoRequestsForMatchingObservation() {
        let reqsA = requests.requestsForKeyPath("kp0", changeKeys: [NSKeyValueChangeNewKey,NSKeyValueChangeOldKey])
        XCTAssertEqual(reqsA.count, 2)
    }

}

