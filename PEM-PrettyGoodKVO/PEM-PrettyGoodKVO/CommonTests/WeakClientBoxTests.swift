//
//  WeakClientBoxTests.swift
//  PEM-PrettyGoodKVO
//
//  Created by Paul Mix on 3/7/16.
//
//

import XCTest
@testable import PrettyGoodKVO

class HashableTestClient: Hashable {
    var hashValue: Int {
        return 9
    }
}
func ==(lhs: HashableTestClient, rhs: HashableTestClient) -> Bool {
    return lhs === rhs
}

class WeakClientBoxTests: XCTestCase {
    
    var strongClient: AnyObject?
    var weakClientBox: WeakClientBox!
    
    override func setUp() {
        super.setUp()
        strongClient = NSObject()
        weakClientBox = WeakClientBox(client: strongClient!)
    }
    
    override func tearDown() {
        strongClient = nil
        weakClientBox = nil
        super.tearDown()
    }

    func testWeakClientBox_conformsToWeakMemorySemantics() {
        XCTAssertTrue(weakClientBox.client === strongClient, "While strongClient is still alive, weakClientBox should maintain a strong reference to the client")
    }
    
    func testWeakClientBox_doesNotMaintainClientReferenceAfterDying() {
        strongClient = nil
        XCTAssertNil(weakClientBox.client, "After strongClient is nillified, weakClientBox should no longer maintain a strong reference to the client")
    }

}


class WeakClientBoxTests_2BoxSameClientEquality: XCTestCase {
    
    var strongClient: AnyObject!
    var weakClientBoxA: WeakClientBox!
    var weakClientBoxB: WeakClientBox!
    
    override func setUp() {
        super.setUp()
        strongClient = NSObject()
        weakClientBoxA = WeakClientBox(client: self.strongClient)
        weakClientBoxB = WeakClientBox(client: self.strongClient)
    }
    
    override func tearDown() {
        strongClient = nil
        weakClientBoxA = nil
        weakClientBoxB = nil
        super.tearDown()
    }
    
    func testWeakClientBox_equalWhileStrongClientAlive() {
        XCTAssertTrue(weakClientBoxA == weakClientBoxB, "While strongClient is still alive, weakClientBoxes should be equal")
    }
    
    func testWeakClientBox_equalAfterStrongClientDies() {
        strongClient = nil
        XCTAssertTrue(weakClientBoxA == weakClientBoxB, "After strongClient is nillified, weakClientBoxes should still be equal")
    }
    
}

class WeakClientBoxTests_2Box2ClientInequality: XCTestCase {
    
    var strongClientA: AnyObject!
    var strongClientB: AnyObject!
    var weakClientBoxA: WeakClientBox!
    var weakClientBoxB: WeakClientBox!
    
    override func setUp() {
        super.setUp()
        strongClientA = NSObject()
        strongClientB = HashableTestClient()
        weakClientBoxA = WeakClientBox(client: strongClientA)
        weakClientBoxB = WeakClientBox(client: strongClientB)
    }
    
    override func tearDown() {
        strongClientA = nil
        strongClientB = nil
        weakClientBoxA = nil
        weakClientBoxB = nil
        super.tearDown()
    }
    
    func testWeakClientBox_notEqualWhileStrongClientAlive() {
        XCTAssertFalse(weakClientBoxA == weakClientBoxB, "While strongClient is still alive, weakClientBoxes should not be equal")
    }
    
    func testWeakClientBox_equalAfterStrongClientDies() {
        strongClientA = nil
        strongClientB = nil
        XCTAssertFalse(weakClientBoxA == weakClientBoxB, "After strongClient is nillified, weakClientBoxes should still not be equal")
    }
    
}

