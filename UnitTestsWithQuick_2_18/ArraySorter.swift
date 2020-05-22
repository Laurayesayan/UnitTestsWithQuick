//
//  ArraySorter.swift
//  UnitTestsWithQuick_2_18
//
//  Created by Лаура Есаян on 22.05.2020.
//  Copyright © 2020 LY. All rights reserved.
//

import Foundation

class ArraySorter<T: Comparable> {
    var array: [T]
    
    init(array: [T]) {
        self.array = array
    }
    
    func getMinimum() -> T {
        var min = array[0]
        for i in 0..<array.count {
            min = array[i] < min ? array[i] : min
        }
        return min
    }
    
    func getMaximum() -> T {
        var max = array[0]
        for i in 0..<array.count {
            max = array[i] > max ? array[i] : max
        }
        return max
    }
    
    func bubbleSort() -> [T] {
        for i in 0..<array.count-1 {
            if array[i] > array[i+1] {
                array.swapAt(i, i+1)
            }
        }
        
        return array
    }
    
    func insertionSort() -> [T] {
        for i in 1..<array.count {
            let up = array[i]
            var j = i - 1
            while j >= 0 && array[j] > up {
                array[j+1] = array[j]
                j -= 1
            }
            array[j + 1] = up
        }
        
        return array
    }
    
    func gnomeSort() -> [T] {
        var index = 0
    
        while index < array.count {
            if index == 0 || array[index] >= array[index - 1] {
                index += 1
            } else {
                array.swapAt(index, index - 1)
                index -= 1
            }
        }
        
        return array
    }
}
