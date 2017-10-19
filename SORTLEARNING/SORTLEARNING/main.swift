//
//  main.swift
//  SORTLEARNING
//
//  Created by 吴文建 on 2017/10/16.
//  Copyright © 2017年 com.xhzxapp. All rights reserved.
//

import Foundation


var intArr = [Int]()
//准备一个数组
for _ in 0..<50{
    let num = Int(arc4random() % 1000	)
    intArr.append(num)
}
print(intArr)

func timeConsum(_ block:(()->())?){
    let start = Date()
    //func here
    block?()
    let end = Date().timeIntervalSince(start)
    print("共耗时:\(end)秒")
}

// MARK: - 选择排序
//选择排序:
func selectionSort(arr:inout [Int]){
    for i in 0..<arr.count-1{
        for j in i+1..<arr.count{
            if arr[i] > arr[j] {
                arr.swapAt(i, j)
//                let temp = arr[j]
//                arr[j] = arr[i]
//                arr[i] = temp
            }
        }
    }
}
// MARK: - 冒泡排序
//冒泡排序
func bubbleSort(arr:inout [Int]){
    for i in 0..<arr.count-1{
        for j in 0..<arr.count-1-i{
            if arr[j] > arr[j+1] {
                let temp = arr[j]
                arr[j] = arr[j+1]
                arr[j+1] = temp
            }
        }
    }
}

// MARK: - 插入排序
/**
 插入排序
 把第一个数当成一个有序数列  后面的数当成要插入的元素
 */
//插入排序
func insertionSorting(arr:inout [Int]){
    for i in 1..<arr.count {
        var j = i-1
        while(j >= 0){
            if arr[j] > arr[j+1] {
              arr.swapAt(j, j+1)
            }else{
                //如果 j 这个元素比 j+1的小 那么前面不用比了 都比 j+1的小
                break
            }
            j -= 1
        }
    }
}

// MARK: - 归并排序
/**
 1. 申请空间，使其大小为两个已经排序序列之和，该空间用来存放合并后的序列；
 
 2. 设定两个指针，最初位置分别为两个已经排序序列的起始位置；
 
 3. 比较两个指针所指向的元素，选择相对小的元素放入到合并空间，并移动指针到下一位置；
 
 4. 重复步骤 3 直到某一指针达到序列尾；
 
 5. 将另一序列剩下的所有元素直接复制到合并序列尾。
 */
//归并排序 - 分
func mergeSort(arr: inout [Int],startIndex: Int,endIndex: Int){
    var midIndex:Int
    if startIndex < endIndex {
        midIndex = (startIndex + endIndex) / 2
        mergeSort(arr: &arr, startIndex: startIndex, endIndex: midIndex)
        mergeSort(arr: &arr, startIndex: midIndex+1, endIndex: endIndex)
        //递归 分完 然后排序
        mergeSort(arr: &arr, startIndex: startIndex, midIndex: midIndex, endIndex: endIndex)
    }
}

/// 归并排序 - 治
func mergeSort(arr:inout [Int],startIndex: Int,midIndex: Int,endIndex: Int){
    //开辟空间 存储排序后序列
    var temp = [Int](repeating: 0, count: endIndex-startIndex+1)
    var i = startIndex,j = midIndex + 1
    //i,j同时走,比较小的值放在temp数组中
    while i <= midIndex && j <= endIndex {
        if arr[i] <= arr[j] {
            temp[i+j-startIndex-midIndex-1] = arr[i]
            i += 1
        }else{
            temp[i+j-startIndex-midIndex-1] = arr[j]
            j += 1
        }
    }
    //i或j已经有一个走完 那么把剩下的填到temp末尾
    while i <= midIndex {
        temp[i+j-startIndex-midIndex-1] = arr[i]
        i += 1
    }
    while j <= endIndex {
        temp[i+j-startIndex-midIndex-1] = arr[j]
        j += 1
    }
    //处理完毕 赋会原数组
    for i in startIndex...endIndex{
        arr[i] = temp[i-startIndex]
    }
}

// MARK: - 快速排序
//以序列第一个值为关键数据
func quickSort1(arr: inout [Int],startIndex: Int,endIndex: Int){
    guard startIndex < endIndex else{ return }
    var i = startIndex,j = endIndex,key = arr[startIndex]
    //当出现 i == j 说明这一组已经排序完毕
    while i < j {
        //从右边寻找比key大的值 把这个值给a[i]
        while i < j && arr[j] >= key {
            j -= 1
        }
        arr[i] = arr[j]
        //继续去从左边寻找比key小的值 把值给a[j]
        while i < j && arr[i] <= key {
            i += 1
        }
        arr[j] = arr[i]
    }
    //排序完毕 key值回归
    arr[i] = key
    //同样的方法 左侧排序  右侧排序
    quickSort1(arr: &arr, startIndex: startIndex, endIndex: i)
    quickSort1(arr: &arr, startIndex: i+1, endIndex: endIndex)
}

// MARK: - 堆排序
/**
 * 1.建最大堆
 * 2.取出堆顶值,将堆底放到堆顶(这时的堆已不符合最大堆的性质)
 * 3.维护剩余元素,使其成为最大堆
 * 4.重复过程 2 3
 * 5.排序完成
 */
func heapSort(arr: inout [Int]){
    var heapSize = arr.count
    //构建最大堆
    buildMaxHeap(arr: &arr, heapSize: heapSize)
    while heapSize > 1 {
        //交换堆顶和堆底的值
        arr.swapAt(0, heapSize-1)
        heapSize -= 1
        //维护剩余元素的最大堆性质
        heapify(arr: &arr, i: 1, heapSize: heapSize)
    }
    
}

//创建最大堆
func buildMaxHeap(arr: inout [Int],heapSize: Int){
    var i = arr.count/2
    while i>0 {
        heapify(arr: &arr, i: i,heapSize: heapSize)
        i-=1
    }
}

func heapify(arr: inout [Int],i: Int,heapSize: Int){
//    for i in 1...arr.count{
        let l = 2*i
        let r = 2*i + 1
        var lagest: Int
        //比较父节点和左孩子
        if(l <= heapSize && arr[l-1] > arr[i-1]) {
            lagest = l
        }else{
            lagest = i
        }
        //比较最大值和右孩子
        if r <= heapSize && arr[r-1] > arr[lagest-1]{
            lagest = r
        }
        if i != lagest {
            //如果交换了值那么父节点就有可能不符合最大堆的性质,需要维护其最大堆的性质
          arr.swapAt(i-1, lagest-1)
          heapify(arr: &arr, i: lagest,heapSize: heapSize)
        }
}


//bubbleSort(arr: &intArr)
//insertionSorting(sortArr: intArr)
//mergeSort(arr: &intArr, startIndex: 0, endIndex: intArr.count-1)
//quickSort1(arr: &intArr, startIndex: 0, endIndex: intArr.count-1)
//heapSort(arr: &intArr)
//    print("选择排序耗时")
//timeConsum {
//  selectionSort(arr: &intArr)
//}
//冒泡排序
//timeConsum {
//    bubbleSort(arr: &intArr)
//}
////插入
//timeConsum {
//    insertionSorting(arr: &intArr)
//}
//快排
//timeConsum {
//    quickSort1(arr: &intArr, startIndex: 0, endIndex: intArr.count-1)
//}
////归并
//timeConsum {
//    mergeSort(arr: &intArr, startIndex: 0, endIndex: intArr.count-1)
//}
////堆排序
timeConsum {
    heapSort(arr: &intArr)
}
print(intArr)

//print(intArr)


