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
 # retryWhen
 */
//사용자가 재시도 버튼을 탭하는 시점에만 재시도하고 싶다면 retryWhen을 사용한다

let bag = DisposeBag()

enum MyError: Error {
   case error
}

var attempts = 1

let source = Observable<Int>.create { observer in
   let currentAttempts = attempts
   print("START #\(currentAttempts)")
   
   if attempts < 3 {
      observer.onError(MyError.error)
      attempts += 1
   }
   
   observer.onNext(1)
   observer.onNext(2)
   observer.onCompleted()
   
   return Disposables.create {
      print("END #\(currentAttempts)")
   }
}

let trigger = PublishSubject<Void>()

// 바로 error를 전달하지 않고 trigger Observable이 리턴할 때까지 대기
source
    .retryWhen{_ in trigger}
   .subscribe { print($0) }
   .disposed(by: bag)

//triger subject가 next이벤트를 전달하면 다시 시도
trigger.onNext(())

//여기서 이제 성공
trigger.onNext(())

