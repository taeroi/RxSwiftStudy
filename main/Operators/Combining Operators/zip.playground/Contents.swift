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
 # zip
 */

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let numbers = PublishSubject<Int>()
let strings = PublishSubject<String>()

//combineLatest와 비교하면 쉽게 이해될듯, 이 연산자도 공식홈페이지를 참고하기

Observable.zip(numbers,strings){"\($0) - \($1)"}
    .subscribe{print($0)}
    .disposed(by: bag)

numbers.onNext(1)
strings.onNext("one")

//이 next이벤튼는 구독자로 전달되지 않고 않고 대기한다 - 짝이 없기 때문에
numbers.onNext(2)

// -----
strings.onNext("two")


//error이벤트가 생기면 그 즉시 구독자에게 전달된다
//numbers.onError(MyError.error)

//completed가 구독자로 전달되면 이후의 요소는 구독자로 전달되지 않는다
numbers.onCompleted()

numbers.onNext(3)
strings.onNext("three")


