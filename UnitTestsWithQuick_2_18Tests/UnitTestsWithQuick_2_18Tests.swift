//
//  UnitTestsWithQuick_2_18Tests.swift
//  UnitTestsWithQuick_2_18Tests
//
//  Created by Лаура Есаян on 22.05.2020.
//  Copyright © 2020 LY. All rights reserved.
//

import Quick
import Nimble
@testable import UnitTestsWithQuick_2_18

class UnitTestsWithQuick_2_18Tests: QuickSpec {
    override func spec() {
        describe("ArraySorter tests") {
            it("is ok") {
                expect(ArraySorter(array: [3, 2, 8, 5]).bubbleSort()).to(equal([2, 3, 5, 8]))
                expect(ArraySorter(array: [1.5, 0.3, -8, -5]).gnomeSort()).to(equal([-8, -5, 0.3, 1.5]))
                expect(ArraySorter(array: [10, 9.2, 100, -0.1]).insertionSort()).to(equal([-0.1, 9.2, 10, 100]))

                expect(ArraySorter(array: [1.5, 0.3, -8, -5]).getMinimum()).to(equal(-8))
                expect(ArraySorter(array: [1.5, 0.3, -8, -5]).getMaximum()).to(equal(1.5))
            }
        }
        
    }
}
