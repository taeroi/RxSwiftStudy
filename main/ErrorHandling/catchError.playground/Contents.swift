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
 # catchError
 */
//RxSwift에서의 Error
//Observable이 Network Request를 받아 구독자(UI update)에게 next이벤트를 전달한다, 하지만 만약 error가 전달되면 구독이 종료되고 더이상 구독자에게 next이벤트를 전달하지 않고 종료되게 된다(ui가 전달되지 않음)
//1. catch 사용: error가 전달되면 새로운 observable을 구독자에게 전달.
//2. retry 사용: observable을 다시 구독.



// next, completed 이벤트는 그대로 전달, error는 전달하지 않음(network 구현시 주로 사용)

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let subject = PublishSubject<Int>()
let recovery = PublishSubject<Int>()

subject
    .catchError{_ in recovery}  //catchError 연산자를 사용하면 구독자에게 error가 전달되지 않음
   .subscribe { print($0) }
   .disposed(by: bag)

subject
    .onError(MyError.error)
//이렇게 error를 전달하면 구독자에게 그대로 전달되고 구독이 종료됨(다른 이벤트는 전달되지 않음)

subject.onNext(11)
//subject는 next이벤트를 전달할 수 없음

//recovery로는 다른 이벤트들을 모두 전달 할 수 있음
recovery.onNext(12)
recovery.onCompleted()
