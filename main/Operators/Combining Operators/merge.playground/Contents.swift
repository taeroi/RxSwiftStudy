//
//  Copyright (c) 2019 KxCoding <kky0317@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import RxSwift

/*:
 # merge
 */

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let oddNumbers = BehaviorSubject(value: 1)
let evenNumbers = BehaviorSubject(value: 2)
let negativeNumbers = BehaviorSubject(value: -1)


//여러 observable을 합치고 방출하는 요소를 순서대로 방출하는 observable을 리턴한다
//하나의 observable로 합치고 순서대로 구독자에게 전달된다

let source = Observable.of(oddNumbers,evenNumbers)

source
    //기본적으로 merge메서드는 제한이 없다, 제한이 있게 하고 싶어할땐 maxConcurrent를 파라미터로 사용하면 된다
    .merge(maxConcurrent: 2)
    .subscribe{print($0)}
    .disposed(by: bag)

oddNumbers.onNext(3)
evenNumbers.onNext(4)

//completed를 구독자에게 전달하면 next이벤트를 더이상 받지 못하고 모든 요소를 구독자에게 전달한다
//error가 전달되면 즉시 구독자에게 전달됨
oddNumbers.onCompleted()


